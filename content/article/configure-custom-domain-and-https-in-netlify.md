---
title: "Configure Custom Domain and HTTPS in Netlify"
date: 2020-05-05T06:31:46-04:00

categories: [tutorial]
tags: [blog, netlify, namecheap, custom domain, https]
author: "Igor Baiborodine"
---

In the [previous post](https://www.kiroule.com/article/start-blogging-with-github-hugo-and-netlify/), I showed you how to create a website and deploy it on Netlify. It is time to enhance it, namely, configure DNS host records, set up a custom domain name and issue an SSL certificate.

<!--more-->

When you deploy for the first time on Netlify, your full site name will include the `netlify.app` domain. Then you can change the randomly generated subdomain name to the subdomain you want, e.g., `awesome-mclean-11186c.netlify.app` to `kiroule.netlify.app` and continue as is.  But it's evident that for your personal website, you should use a custom domain.

Using a custom domain has the following advantages:\
**Firstly**, lorem ipsum.

**Secondly**, lorem ipsum.

**Thirdly**, lorem ipsum

* why it should be https
* elaborate on Let's Encrypt

This tutorial has the following tasks to complete:

1. [Buy Domain Name](#buy-domain-name)
2. [Configure DNS Host Records](#configure-dns-host-records)
3. [Set up Custom Domain](#set-up-custom-domain)
4. [Update Base URL](#update-base-url)
5. [Issue SSL Certificate](#issue-ssl-certificate)

### Buy Domain Name
TODO: elaborate on options how to buy a domain name
* many available options, can buy from Netlify too, but I bought mine a long time ago from Namecheap.
* some provide hosting too, but we don't need it since we host with Netlify: https://hostingcanada.org/domain-registrars/

### Configure DNS Host Records
![Namecheap Domain List](/img/content/article/configure-custom-domain-in-netlify/namecheap-domain-list.png)

![Namecheap Domain View](/img/content/article/configure-custom-domain-in-netlify/namecheap-domain-view.png)

![Namecheap Domain Advanced DNS](/img/content/article/configure-custom-domain-in-netlify/namecheap-domain-advanced-dns.png)

### Set up Custom Domain
![Netlify Sites View](/img/content/article/configure-custom-domain-in-netlify/netlify-sites-view.png)

![Netlify Site Getting Started](/img/content/article/configure-custom-domain-in-netlify/netlify-site-getting-started.png)

![Netlify Site Settings Add Custom Domain](/img/content/article/configure-custom-domain-in-netlify/netlify-site-settings-add-custom-domain.png)

![Netlify Site Settings Add Custom Domain Owner Confirm](/img/content/article/configure-custom-domain-in-netlify/netlify-site-settings-add-custom-domain-owner-confirm.png)

Your site should be available at these three domains:

![Netlify Site Settings Domain Management](/img/content/article/configure-custom-domain-in-netlify/netlify-site-settings-domain-management.png)

### Update Base URL
baseURL = "https://www.kiroule.com/" - primary domain

### Issue SSL Certificate

![Netlify Site Settings Domain Management HTTPS](/img/content/article/configure-custom-domain-in-netlify/netlify-site-settings-domain-management-https.png)

![Netlify Site Settings Domain Management HTTPS Certificate](/img/content/article/configure-custom-domain-in-netlify/netlify-site-settings-domain-management-https-certificate.png)

![Netlify Site Settings Domain Management HTTPS Certificate Confirm](/img/content/article/configure-custom-domain-in-netlify/netlify-site-settings-domain-management-https-certificate-confirm.png)

![Netlify Site Settings Domain Management HTTPS Enabled](/img/content/article/configure-custom-domain-in-netlify/netlify-site-settings-domain-management-https-enabled.png)

![Website New BaseURL](/img/content/article/configure-custom-domain-in-netlify/website-new-baseurl.png)

