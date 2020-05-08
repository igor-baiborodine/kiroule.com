---
title: "Configure Custom Domain and HTTPS in Netlify"
date: 2020-05-05T06:31:46-04:00

categories: [Blog]
tags: [Netlify, Namecheap, Domain, HTTPS]
author: "Igor Baiborodine"
---

In the [previous post](https://www.kiroule.com/article/start-blogging-with-github-hugo-and-netlify/), I showed you how to create a website and deploy it on Netlify. It is time to enhance it, namely, configure DNS host records, set up a custom domain name and issue an SSL certificate.

<!--more-->

When you deploy for the first time on Netlify, a Netlify subdomain will be assigned to your site, for example, `awesome-mclean-11186c.netlify.app`. Then you can change the randomly generated part in the subdomain to the site name you want, like adjusting `awesome-mclean-11186c.netlify.app` to `kiroule.netlify.app`, and continue as is.  But it's evident that for your personal website, you should use a custom domain, which helps a lot in promoting yourself as a brand and improving credibility. Also, owning a domain comes with the option of having personalized email addresses, for example, `igor@kiroule.com`, which I put on my About page.

As for HTTPS, even if it's your blog where you do not collect any sensitive information, having a secure connection gives the perception of you as a trusted source. Other than that, it also can slightly improve your Google search engine rankings. 

This tutorial has the following tasks to complete:

1. [Configure DNS Records](#configure-dns-records)
2. [Set up Custom Domain](#set-up-custom-domain)
3. [Update Base URL](#update-base-url)
4. [Issue SSL Certificate](#issue-ssl-certificate)

The only prerequisite here is that you take care to purchase a domain name in advance. There are a few domain registrars to choose from (e.g.,  Bluehost, GoDaddy or Namecheap). As for Netlify, they also sell and register domain names:

![Namecheap Choose Domain](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-choose-domain.png)

### Configure DNS Records
DNS (Domain Name System) records are rules that define how domain name servers handle traffic to domains and subdomains. Updating DNS records is a necessary step, once you obtain your custom domain. In our case, this will allow you to connect the domain to Netlify hosting. Since I bought `kiroule.com` domain name from Namecheap, it's shown here how to do that in the Namecheap account, but the same configuration procedure can be done with any domain name registrar.

After signing in to Namecheap, select `Domain List` from the left sidebar and click on the `Manage` button:

![Namecheap Domain List](/img/content/article/configure-custom-domain-and-https-in-netlify/namecheap-domain-list.png)

In the `Details` view, choose the `Advanced DNS` tab:
 
![Namecheap Domain View](/img/content/article/configure-custom-domain-and-https-in-netlify/namecheap-domain-view.png)

In the `Host Records` section, add `A Record` and `ALIAS Record`entries.

`A Record` is an address record, which maps host names to their IPv4 addresses. To configure it, use the following settings:
```plaintext
Type: A Record
Host: @
Value: 104.198.14.52
TTL: 30 min
```
Here, the `104.198.14.52`  value is Netlify's load balancer IP address.

`ALIAS Record` is a virtual host record, which allows pointing one domain name to another one. To configure it, use the following settings:
```plaintext
Type: ALIAS Record
Host: www
Value: [name-of-your-site].netlify.app
TTL: 5 min
```

`TTL` (Time to live) is a propagation time, which defines how fast a DNS record update is pushed to DNS servers around the world.   

![Namecheap Domain Advanced DNS](/img/content/article/configure-custom-domain-and-https-in-netlify/namecheap-domain-advanced-dns.png)

### Set up Custom Domain

Sign in to Netlify and navigate to the site in question:

![Netlify Sites View](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-sites-view.png)

Select `Set up a custom domain` in the `Overview` tab:

![Netlify Site Getting Started](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-getting-started.png)

Enter your custom domain value and click on the `Verify` button:

![Netlify Site Settings Add Custom Domain](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-settings-add-custom-domain.png)

Then confirm that you own the domain name by clicking the "Yes, add domain" button:

![Netlify Site Settings Add Custom Domain Owner Confirm](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-settings-add-custom-domain-owner-confirm.png)

To make sure that the custom domain is correctly configured, open the `Settings` tab and select `Domain management` from the left sidebar. The `Custom domains` section should contain three custom domains: Netlify's default subdomain, your domain and your domain prefixed with `www.`.

![Netlify Site Settings Domain Management](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-settings-domain-management.png)

### Update Base URL
baseURL = "https://www.kiroule.com/" - primary domain

### Issue SSL Certificate

![Netlify Site Settings Domain Management HTTPS](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-settings-domain-management-https.png)

![Netlify Site Settings Domain Management HTTPS Certificate](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-settings-domain-management-https-certificate.png)

![Netlify Site Settings Domain Management HTTPS Certificate Confirm](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-settings-domain-management-https-certificate-confirm.png)

![Netlify Site Settings Domain Management HTTPS Enabled](/img/content/article/configure-custom-domain-and-https-in-netlify/netlify-site-settings-domain-management-https-enabled.png)

![Website New BaseURL](/img/content/article/configure-custom-domain-and-https-in-netlify/website-new-baseurl.png)

