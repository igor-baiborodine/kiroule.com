---
title: "Configure Custom Domain and HTTPS in Netlify"
date: 2020-05-05T06:31:46-04:00

categories: [tutorial]
tags: [blog, netlify, namecheap, custom domain, https]
author: "Igor Baiborodine"
---

TODO: introduction

<!--more-->

Article Plan:

* Introduction
* Quick intro on how to buy a domain name
    * TODO: many available options, can buy from Netlify too, but I bought mine a long time ago from Namecheap.

* NameCheap configuration
* Netlify configuration

### Configure Host Records
![Namecheap Domain List](/img/content/article/configure-custom-domain-in-netlify/namecheap-domain-list.png)

![Namecheap Domain View](/img/content/article/configure-custom-domain-in-netlify/namecheap-domain-view.png)

![Namecheap Domain Advanced DNS](/img/content/article/configure-custom-domain-in-netlify/namecheap-domain-advanced-dns.png)

### Configure Custom Domain

![Netlify Sites View](/img/content/article/configure-custom-domain-in-netlify/netlify-sites-view.png)

![Netlify Site Getting Started](/img/content/article/configure-custom-domain-in-netlify/netlify-site-getting-started.png)

![Netlify Site Settings Add Custom Domain](/img/content/article/configure-custom-domain-in-netlify/netlify-site-settings-add-custom-domain.png)

![Netlify Site Settings Add Custom Domain Owner Confirm](/img/content/article/configure-custom-domain-in-netlify/netlify-site-settings-add-custom-domain-owner-confirm.png)

Your site should be available at these three domains:

![Netlify Site Settings Domain Management](/img/content/article/configure-custom-domain-in-netlify/netlify-site-settings-domain-management.png)

### Update Base URL
baseURL = "https://www.kiroule.com/" - primary domain

### Configure HTTPS

![Netlify Site Settings Domain Management HTTPS](/img/content/article/configure-custom-domain-in-netlify/netlify-site-settings-domain-management-https.png)

![Netlify Site Settings Domain Management HTTPS Certificate](/img/content/article/configure-custom-domain-in-netlify/netlify-site-settings-domain-management-https-certificate.png)

![Netlify Site Settings Domain Management HTTPS Certificate Confirm](/img/content/article/configure-custom-domain-in-netlify/netlify-site-settings-domain-management-https-certificate-confirm.png)

![Netlify Site Settings Domain Management HTTPS Enabled](/img/content/article/configure-custom-domain-in-netlify/netlify-site-settings-domain-management-https-enabled.png)

![Website New BaseURL](/img/content/article/configure-custom-domain-in-netlify/website-new-baseurl.png)





