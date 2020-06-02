#!/bin/bash

set -u

#
# Algolia Diag v2
#

DEBUG=0
PINGS=20
TRACE_WAIT=2
TRACE_HOPS=30
CURL_TIMEOUT=5

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m'
#

_print_green() {
    echo -ne "${GREEN}$1${NC}"
}

_print_red() {
    echo -ne "${RED}$1${NC}"
}

_print_orange() {
    echo -ne "${ORANGE}$1${NC}"
}

_print_result() {
    echo -ne "${2}: "
    if [[ ${1} -eq 0 ]]; then
        _print_green 'OK'
    elif [[ ${1} -eq -1 ]]; then
        _print_orange 'Not Available'
    else
        _print_red 'Failure'
    fi
    echo ""
}

_test_start() {
    echo -ne "${1}: "
}

_test_finish() {
    if [[ ${1} -eq 0 ]]; then
        _print_green 'OK'
    elif [[ ${1} -eq -1 ]]; then
        _print_orange 'Not Available'
    else
        _print_red "Failure\n${2}"
    fi
    echo ""
}

# App
TMP_FILE=`mktemp`
CURL_CONFIG='-- %{time_namelookup} - %{time_connect} - %{time_appconnect} - %{time_starttransfer} - %{time_total}'

_run() {
    if `which ${2} >> /dev/null`; then
        echo -e "######\n# $1\n######" >> $TMP_FILE
        _test_start "${1}"
        OUTPUT=`bash -c "${2} ${3}" >> $TMP_FILE 2>&1`
        RESULT=$?
        if [[ $# -eq 5 ]] && [[ ${4} -eq 1 ]]; then
            _test_finish !$RESULT "${5}"
        elif [[ $# -eq 4 ]]; then
            _test_finish $RESULT "${4}"
        else
            _test_finish $RESULT "Failing this test does not indicate any specific issue"
        fi
        echo "" >> $TMP_FILE
        return $RESULT
    else
        _test_start "${1}"
        _test_finish -1 "${1} (${2})"
    fi
}

if [[ ! -e $TMP_FILE ]]; then
    _print_red "Temporary file not created\n"
fi

if [[ ! `id -u` -eq 0 ]]; then
    _print_red "Not running as root! Some tests might not work\n"
fi

appids=( latency )

if [[ $# -eq 1 ]]; then
    appids+=(${1})
    _print_green "Adding test for APPID: ${1}\n"
else
    _print_orange "No specific Application ID provided, testing will be performed against a global one. \
\nTo provide Application ID, run: ${0} <APPID>\n"
fi

_print_green "Ready to start!\n"
_print_orange "The tests will run for few minutes!\n"

if [[ $DEBUG -eq 1 ]]; then
    # test for "Not Availale"
    _run    "Private Fail"     "npriv" "whois"

    # test for Failure
    _run    "Ping Fail"        "ping" "-c ${PINGS} latency-ds.algolia.net"
    _run    "Hosts-google"       "cat" "/etc/hosts | grep 'google.com'" 1
fi

_run    System-Info \
            "uname" \
            "-a"
_run    DNS-Settings \
           "cat" \
           "/etc/resolv.conf"
_run    Dig  \
            "dig" \
            "TXT whoami.ds.akahelp.net" \
            "Failing this test mostly indicates your DNS resolver does not work properly."
_run    Dig-v6 \
            "dig" \
            "TXT whoami.ipv6.akahelp.net"
_run    Dig-v4 \
            "dig" \
            "TXT whoami.ipv4.akahelp.net"
_run    Dig-Trace \
            "dig" \
            "TXT whoami.ds.akahelp.net +trace"
_run    Port-80 \
            "curl" \
            "-s --connect-timeout ${CURL_TIMEOUT} -w '${CURL_CONFIG}' www.google.com:80" \
            "Failing this test mostly indicates you have a network problem.\n"
_run    Port-443 \
            "curl" \
            "-s -k --connect-timeout ${CURL_TIMEOUT} -w '${CURL_CONFIG}' -o /dev/null https://www.google.com:443"
_run    Geo \
            "curl" \
            "-s -H 'Accept: */json' -w '${CURL_CONFIG}' https://geoip.me"
_run    Hosts-net \
            "cat" \
            "/etc/hosts | grep 'algolia.net'" 1 \
            "Failing this test indicates you have custom /etc/hosts configuration for algolia.net domain which can interfere with proper working on Algolia."
_run    Hosts-com  \
             "cat" \
             "/etc/hosts | grep 'algolianet.com'" 1 \
            "Failing this test indicates you have custom /etc/hosts configuration for algolianet.com domain which can interfere with proper working on Algolia."

for app in "${appids[@]}"
do
    for endpoint in "${app}-dsn.algolia.net" "${app}-1.algolianet.com" "${app}-2.algolianet.com" "${app}-3.algolianet.com"
    do
        # Testset
        _run    "Dig-Google - ${endpoint}" \
                "dig" \
                "${endpoint} @8.8.8.8" \
                "Failing this test indicates you cannot resolve Algolia domain using Google DNS resolver"
        _run    "Dig-CF - ${endpoint}" \
                "dig" \
                "${endpoint} @1.1.1.1" \
                "Failing this test indicates you cannot resolve Algolia domain using Cloudflare DNS resolver"
        _run    "Ping - ${endpoint}" \
                "ping" \
                "-c ${PINGS} ${endpoint}"
        _run    "Trace - ${endpoint}" \
                "traceroute" \
                "-w ${TRACE_WAIT} -m ${TRACE_HOPS} ${endpoint}"
        _run    "Trace-ICMP - ${endpoint}" \
                "traceroute" \
                "-I -w ${TRACE_WAIT} -m ${TRACE_HOPS} ${endpoint}"
        _run    "Connect - ${endpoint}" \
                "curl" \
                "-s --connect-timeout ${CURL_TIMEOUT} -w '${CURL_CONFIG}' https://${endpoint}/1/isalive"
        _run    "MTR - ${endpoint}" \
                "mtr" \
                "-r -c 100 -n ${endpoint}"
    done
done

URL=`cat $TMP_FILE | curl -s -F 'f:1=<-' ix.io`

echo -ne "\n\n===================\nEnd of diagnostics, please send this url: "
_print_orange $URL
echo -e " to Algolia support, either by replying to the person that asked you \
to run the script or by sending a new email including your Application ID \
and why you had to run the script"

rm $TMP_FILE

exit 0
