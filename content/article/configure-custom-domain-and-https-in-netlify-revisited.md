---
title: "Configure Custom Domain and HTTPS in Netlify: Revisited"
date: 2021-10-20T07:53:45-04:00

categories: [Jamstack, Tutorial]
tags: [Subdomain, Netlify, Namecheap]
toc: false
series: "Building Your Blog, the Geeky Way"
author: "Igor Baiborodine"
aliases:
    - /article/configure-custom-subdomain-and-https-on-netlify/
---

After publishing the article ["Configure Custom Domain and HTTPS in Netlify,"](/article/configure-custom-domain-and-https-in-netlify) one reader asked in the comments if the same instructions could be used to set up a custom **subdomain**.
So in this post, I will expand on my answer.

<!--more-->

A subdomain or child domain is an extension of your primary domain name. 
Subdomains can be used not only to organize and navigate to different sections of a website but also to publish different websites. 
Since I own the `kiroule.com` domain, I could have published my blog under the `blog.kiroule.com` subdomain. Also, a subdomain can contain multiple levels, for instance, `info.blog.kiroule.com`.

You can create multiple subdomains in your main domain. 
The exact number of subdomains that can be configured should be checked with your domain registrar. 
For example, Namecheap allows you to use up to 150 subdomains per domain name.

Therefore, if you decide to use a subdomain for your website when hosting it on Netlify, given that the domain name is not registered with Netlify and comes from an external registrar like Bluehost, GoDaddy, Namecheap, etc., you can follow the steps that I outlined in the article ["Configure Custom Domain and HTTPS in Netlify."](/article/configure-custom-domain-and-https-in-netlify) 
The difference will be in configuring the `ALIAS Record` properties in the ["Configure DNS Records"](/article/configure-custom-domain-and-https-in-netlify/#configure-dns-records) step.

Here is the configuration with the primary domain:
```plaintext
Type: ALIAS Record
Host: www
Value: [name-of-your-site].netlify.app
TTL: 5 min
```

With a subdomain, you must add the subdomain name as a suffix to the `www` in the value of the `Host` property:
```plaintext
Type: ALIAS Record
Host: www.[name-of-your-subdomain]
Value: [name-of-your-site].netlify.app
TTL: 5 min
```

Also, when [setting up the custom domain in Netlify](/article/configure-custom-domain-and-https-in-netlify/#set-up-custom-domain) and [updating the base URL](/article/configure-custom-domain-and-https-in-netlify/#update-base-url), the full custom domain value should contain the subdomain: `www.<subdomain>.<domain-name>`.

As for me, after creating my blog and setting up the `kiroule.com` domain and HTTPS in Netlify, I wanted to use a subdomain to publish another website, also hosted on Netlify. 
So I have a test website https://bilberry-sandbox.netlify.app/ that I am using to test my contributions to the Bilberry Hugo theme. 
To make it available as the `bilberry-sandbox` subdomain of `kiroule.com`, I followed the instructions from my article mentioned above, except for the `ALIAS record` and Netlify custom domain set-up configuration:

```
Type: ALIAS Record
Host: www.bilberry-sandbox
Value: bilberry-sandbox.netlify.app
TTL: 5 min
```

![Netlify Site Settings Add Custom Domain](/img/content/article/configure-custom-domain-and-https-in-netlify-revisited/netlify-site-settings-add-custom-domain.png)

And now my test website is available at https://www.bilberry-sandbox.kiroule.com.

Continue reading the series ["Building Your Blog, the Geeky Way"](/series/building-your-blog-the-geeky-way/):
{{< series "Building Your Blog, the Geeky Way" >}}
