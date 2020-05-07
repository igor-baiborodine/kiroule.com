---
title: "Configure Custom Domain and HTTPS in Netlify"
date: 2020-05-05T06:31:46-04:00

categories: [tutorial]
tags: [blog, netlify, namecheap, custom domain, https]
author: "Igor Baiborodine"
---

In the [previous post](https://www.kiroule.com/article/start-blogging-with-github-hugo-and-netlify/), I showed you how to create a website and deploy it on Netlify. It is time to enhance it, namely, configure DNS host records, set up a custom domain name and issue an SSL certificate.

<!--more-->

When you deploy for the first time on Netlify, your full site name will include the `netlify.app` domain. Then you can change the randomly generated subdomain name to the subdomain you want, e.g., `awesome-mclean-11186c.netlify.app` to `kiroule.netlify.app` and continue as is.  But it's evident that for your personal website, you should use a custom domain, which helps a lot in promoting yourself as a brand and improving credibility. Also, owning a custom domain comes with the option of having personalized email addresses, e.g., `igor@kiroule.com`, which I used on my About page.

As for HTTPS, even if it's your blog where you do not collect any sensitive information, having a secure connection gives the perception of you as a trusted source. Other than that, it also can slightly boost your Google search engine rankings. 

This tutorial has the following tasks to complete:

1. [Configure DNS Host Records](#configure-dns-host-records)
2. [Set up Custom Domain](#set-up-custom-domain)
3. [Update Base URL](#update-base-url)
4. [Issue SSL Certificate](#issue-ssl-certificate)

The only condition here is that you take care to purchase a domain name in advance. There are several domain registrars to choose from, e.g.,  Bluehost, GoDaddy or Namecheap. As for Netlify, they also sell and register domain names:

![Namecheap Choose Domain](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-choose-domain.png)

### Configure DNS Host Records
![Namecheap Domain List](/img/content/article/configure-custom-domain-and-https-in-netlify/namecheap-domain-list.png)

![Namecheap Domain View](/img/content/article/configure-custom-domain-and-https-in-netlify/namecheap-domain-view.png)

![Namecheap Domain Advanced DNS](/img/content/article/configure-custom-domain-and-https-in-netlify/namecheap-domain-advanced-dns.png)

### Set up Custom Domain
![Netlify Sites View](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-sites-view.png)

![Netlify Site Getting Started](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-getting-started.png)

![Netlify Site Settings Add Custom Domain](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-settings-add-custom-domain.png)

![Netlify Site Settings Add Custom Domain Owner Confirm](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-settings-add-custom-domain-owner-confirm.png)

Your site should be available at these three domains:

![Netlify Site Settings Domain Management](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-settings-domain-management.png)

### Update Base URL
baseURL = "https://www.kiroule.com/" - primary domain

### Issue SSL Certificate

![Netlify Site Settings Domain Management HTTPS](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-settings-domain-management-https.png)

![Netlify Site Settings Domain Management HTTPS Certificate](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-settings-domain-management-https-certificate.png)

![Netlify Site Settings Domain Management HTTPS Certificate Confirm](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-settings-domain-management-https-certificate-confirm.png)

![Netlify Site Settings Domain Management HTTPS Enabled](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-settings-domain-management-https-enabled.png)

![Website New BaseURL](/img/content/article/configure-custom-domain-and-https-in-netlify/website-new-baseurl.png)

