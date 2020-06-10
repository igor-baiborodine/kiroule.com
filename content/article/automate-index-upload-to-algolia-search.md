---
title: "Automate Index Upload to Algolia Search"
date: 2020-06-03T06:24:20-04:00

categories: [Blog, Write-Up]
tags: [Automation, Netlify, Algolia]
author: "Igor Baiborodine"
summary: 'This post summarizes how to automate the manual upload of index records to Algolia if you use Netlify to host your website. With this enhancement, every time you add new or update existing content, it will be automatically indexed and uploaded to Algolia. This article is the fourth part of the series "Building Your Blog, the Geeky Way".'
---

This post summarizes how to automate the manual upload of index records to Algolia if you use Netlify to host your website. With this enhancement, every time you add new or update existing content, it will be automatically indexed and uploaded to Algolia. This article is the fourth part of the [series "Building Your Blog, the Geeky Way"](https://www.kiroule.com/article/building-your-blog-the-geeky-way/).

The [Bilberry theme](https://themes.gohugo.io/bilberry-hugo-theme/), which I used to create my website, comes with built-in search functionality. It's implemented using the Algolia search engine.  To activate this feature, what you need is to get a free-tier plan at [algolia.com](https://www.algolia.com/), populate corresponding Algolia params in the `config.toml` file and upload to Algolia generated index records, namely the content of the `public/index.json` file. You can upload them either manually or using [Algolia's API](https://www.algolia.com/doc/api-reference/api-methods/). 

I use Netlify to host my website, and all websites on Netlify by default are built using a Docker image based on Ubuntu 16.04 LTS.  Netlify's [Ubuntu image](https://github.com/netlify/build-image/blob/v3.3.15/Dockerfile) comes with both Python 2 and 3 preinstalled. Therefore, it would be logical to use Algolia API's [Python client](https://github.com/algolia/algoliasearch-client-python) to implement a script that reads the `public/index.json` file and uploads index records to Algolia. Then this Python script can be wrapped in a shell script that is executed right after the `hugo` command during the build. The default build command defined in the section `Build settings` of site's `Build & deploy` configuration on Netlify should be overridden to call this shell script.

The proper way to do that is to use the `netlify.toml` configuration file where the build command and environment variables can be defined per the deployment context, for instance, `prod` and `dev`.  Also, environment variables that are common for all deployment contexts, including sensitive configuration (e.g., the Algolia admin API key), can be defined at the site level in the section `Environment variables`. Since each deployment context is mapped to its proper Algolia index, the `algolia_indexName` param in the `config.toml` file should be initialized with the corresponding index name. It can be achieved by implementing an auxiliary shell script that should be executed before the `hugo` command.

Let's take a closer look at how this solution is implemented. The source code is available [here](https://github.com/igor-baiborodine/kiroule.com).
1. [Algolia Indices](#algolia-indices)
2. [index-upload.py](#index-uploadpy)
3. [run-index-upload.sh](#run-index-uploadsh)
4. [config.sh](#configsh)
5. [config.toml](#configtoml)
6. [netlify.toml](#netlifytoml)
7. [Netlify Configuration](#netlify-configuration)
8. [Dev and Master Branch Deployments](#dev-and-master-branch-deployments)

### Algolia Indices
The very first step is to create and configure Algolia indices at [algolia.com](https://www.algolia.com/), one for each Git branch plus one additional index for the local dev environment. The `master` branch is mapped to the production environment, namely [kiroule.com](https://www.kiroule.com/). All development is done in the `dev` branch, which deployed and tested at [dev--kiroule.netlify.app](https://dev--kiroule.netlify.app/) before merging it into the `master`. Therefore, the following indices are needed: `prod_kiroule`, `dev_kiroule` and `local_dev_kiroule`.

![Algolia Indices List](/img/content/article/automate-index-upload-to-algolia-search/algolia-indices-list.png)

Each newly created index should be configured as follows: in the tab `Configuration`, select the `Facets` in the section `FILTERING AND FACETING` and add the `language` attribute with the `filter only` modifier in the `Attributes for faceting` option. The **Unknown Attribute** error can be ignored because the index has no records.

![Algolia Index Config](/img/content/article/automate-index-upload-to-algolia-search/algolia-index-config.png)

### index-upload.py
The `index-upload.py` script reads the `public/index.json` file and uploads index records to Algolia. Before testing it in the local dev environment, install Algolia API's [Python client](https://github.com/algolia/algoliasearch-client-python) using the `pip` utility:
```shell script
$ pip install --upgrade 'algoliasearch>=2.0,<3.0'
```

The script is implemented as follows:
```python
import argparse
import json
from algoliasearch.search_client import SearchClient

parser = argparse.ArgumentParser()
parser.add_argument('-f', '--index_file', help="Index file to upload to Algolia")
parser.add_argument('-a', '--app_id', help="Algolia application ID")
parser.add_argument('-k', '--admin_api_key', help="Algolia admin API key")
parser.add_argument('-n', '--index_name', help="Algolia index name")
args = parser.parse_args()

with open(args.index_file, 'r') as file:
    indices_json = file.read().replace('\n', '')

indices = json.loads(indices_json)
client = SearchClient.create(args.app_id, args.admin_api_key)
index = client.init_index(args.index_name)
index.save_objects(indices)
```

To generate the `index.json` file containing index records, execute the `hugo` command in the site's root directory:

![Python Script Hugo Build](/img/content/article/automate-index-upload-to-algolia-search/python-script-hugo-build.png)

To do testing in the local dev, run the script from the command line as follows:

```shell script
$ cd algolia
$ index-upload.py -f ../public/index.json -a <algolia-app-id> -k <algolia-admin-api-key> -n <alogolia-index-name>
```
Or create a `Run/Debug` configuration in **IntelliJ IDEA**, for instance:

![Python Script Run Configuration](/img/content/article/automate-index-upload-to-algolia-search/python-script-run-configuration.png)

In the case of the script's successful execution, the index entries will be uploaded to Algolia into the corresponding index. That can be verified in the application's section `Indices` on Algolia by comparing the number of records before and after the script execution:

![Python Script Algolia Indices View](/img/content/article/automate-index-upload-to-algolia-search/python-script-algolia-indices-view.png)

### run-index-upload.sh
The `run-index-upload.sh` script is a wrapper shell script for the `index-upload.py` script. It can be executed either in the `netlify` or `local dev` mode. When it runs with the `-p` flag, i.e., in the `netlify` mode, Algolia API's Python client is installed, and `index-upload.py` script's arguments are initialized with the corresponding environment variables.

The script is implemented as follows:
```shell script
#!/usr/bin/env bash
while getopts "pf:a:k:n:" opt; do
  case $opt in
  # netlify
  p) pip install --upgrade 'algoliasearch>=2.0,<3.0'
     # Environment variables below (except PWD) should be configured
     # in the section 'Build & deploy/Environment variables' of your site in Netlify;
     # Alternatively, the ALGOLIA_INDEX_NAME variable can be defined in the netlify.toml file.
     index_file="$PWD/$HUGO_INDEX_FILE"
     app_id="$ALGOLIA_APP_ID"
     admin_api_key="$ALGOLIA_ADMIN_API_KEY"
     index_name="$ALGOLIA_INDEX_NAME" ;;
  # local dev
  f) index_file="$OPTARG" ;;
  a) app_id="$OPTARG" ;;
  k) admin_api_key="$OPTARG" ;;
  n) index_name="$OPTARG" ;;
  \?) echo "Invalid option: -$OPTARG" >&2 ;;
  esac
done

python algolia/index-upload.py \
    -f "$index_file" \
    -a "$app_id" \
    -k "$admin_api_key" \
    -n "$index_name"
```
To test in the local dev, run the script from the command line or via a `Run/Debug` configuration in **IntelliJ IDEA**. After the script execution, verify the `Last build` value in the application's section `Indices` on Algolia.

### config.sh
The `config.sh` script is an auxiliary shell script that initializes the `algolia_indexName` param in the `config.toml` file with the corresponding index name. It should be executed before the `hugo` command.

The script is implemented as follows:
```shell script
#!/usr/bin/env bash
sed -i "s/ALGOLIA_INDEX_NAME_PLACEHOLDER/${ALGOLIA_INDEX_NAME}/g" config.toml
grep 'algolia_indexName' config.toml
```

### config.toml
The Algolia params in the `config.toml` file should be populated with corresponding values. The `algolia_apiKey` param value here is the public API key that is only usable for search queries from the front end.

```toml
# Enable / Disable algolia search
  algolia_search    = true
  algolia_appId     = "NLO8K25GU4"
  algolia_apiKey    = "1ea1d7b821a9feb925c6bed046281341"
  algolia_indexName = "ALGOLIA_INDEX_NAME_PLACEHOLDER"
  # Set this option to false if you want to search within all articles in all languages at once
  algolia_currentLanguageOnly = true
```

### netlify.toml
The `netlify.toml` file contains the following configuration:

```toml
[build]
  publish = "public"
  command = "hugo"

# URL: https://kiroule.com/
[context.production.environment]
  HUGO_VERSION = "0.72.0"
  HUGO_ENV = "production"
  HUGO_ENABLEGITINFO = "true"
  ALGOLIA_INDEX_NAME = "prod_kiroule"

[context.production]
  command = "./config.sh && hugo --buildFuture && algolia/run-index-upload.sh -p"

# URL: https://dev--kiroule.netlify.app/
[context.dev.environment]
  HUGO_VERSION = "0.72.0"
  ALGOLIA_INDEX_NAME = "dev_kiroule"

[context.dev]
  command = "./config.sh && hugo -b $DEPLOY_PRIME_URL --buildFuture && algolia/run-index-upload.sh -p"
```
The `ALGOLIA_INDEX_NAME` environment variable is defined per the deployment context.

### Netlify Configuration
The deployment contexts should be defined accordingly in the section `Deploy contexts` of the `Build & deploy` site settings:

![Netlify Deploy Contexts Configuration](/img/content/article/automate-index-upload-to-algolia-search/netlify-deploy-contexts-config.png)

Environment variables that are common for all deployment contexts are defined at the site level in the section `Environment variables`. The `ALGOLIA_ADMIN_API_KEY` environment variable should be kept secret and is used to create, update, and delete indices.

![Netlify Environment Variables Configuration](/img/content/article/automate-index-upload-to-algolia-search/netlify-env-var-config.png)

### Dev and Master Branch Deployments
Following the successful tests in the local dev environment, the changes in the local `dev` branch can be committed and pushed to the remote `dev` branch on GitHub.  That will trigger build and deploy in the `dev` branch deployment context on Netlify. Successful indices upload to Algolia can be verified by checking the number of records contained in the 'dev_kiroule' index.  The search feature should now be fully functional at [dev--kiroule.netlify.app](https://dev--kiroule.netlify.app/). 

After merging the `dev` branch into the `master` branch on GitHub, the search feature should also work at [kiroule.com](https://www.kiroule.com/):

![Kiroule Prod Test Search](/img/content/article/automate-index-upload-to-algolia-search/kiroule-prod-test-search.gif)

*Q.E.D.*

More articles in this series:  
**[Start Blogging With Hugo, GitHub and Netlify](https://www.kiroule.com/article/start-blogging-with-github-hugo-and-netlify/)**  
**[Configure Custom Domain and HTTPS on Netlify](https://www.kiroule.com/article/configure-custom-domain-and-https-in-netlify/)**  
**[Add Favicon to Hugo-Based Website](https://www.kiroule.com/article/add-favicon-to-hugo-based-website/)**  
