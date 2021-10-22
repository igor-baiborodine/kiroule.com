---
title: "Configure Custom Subdomain on Netlify Using External Registrar"
date: 2021-10-20T07:53:45-04:00
categories: [Jamstack, Tutorial]
tags: [Subdomain, Netlify, Namecheap]
series: "Building Your Blog, the Geeky Way"
author: "Igor Baiborodine"
---

After publishing the article ["Configure Custom Domain and HTTPS on Netlify,"](/article/configure-custom-domain-and-https-in-netlify) one reader asked if the same instructions could be used to set up a custom subdomain. So in this post, I expand my answer and detail how to do this with external registrars.

<!--more-->

A subdomain or child domain is an extension of your primary domain name. 
Subdomains can be used not only to organize and navigate to different sections of a website but also to publish different websites. 
Since I own the `kiroule.com` domain, I could have published my blog under the `blog.kiroule.com` subdomain. Also, a subdomain can contain multiple levels, for instance, `info.blog.kiroule.com`.

You can create multiple subdomains in your main domain. 
The exact number of subdomains that can be configured should be checked with your domain registrar. 
For example, *Namecheap* allows you to use up to 150 subdomains per domain name.

Therefore, if you decide to use a subdomain for your website when hosting it on Netlify, given that the domain name is not registered with Netlify and comes from an external registrar like GoDaddy, Namecheap, etc., you can follow the steps that I outlined in the article ["Configure Custom Domain and HTTPS on Netlify."](/article/configure-custom-domain-and-https-in-netlify) 
The only difference will be in configuring the `ALIAS record` parameters in the ["Configure DNS Records"](/article/configure-custom-domain-and-https-in-netlify/#configure-dns-records) step.

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
