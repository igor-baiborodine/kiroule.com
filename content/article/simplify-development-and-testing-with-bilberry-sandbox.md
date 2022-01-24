---
title: "Simplify Development and Testing With Bilberry Sandbox"
date: 2022-01-20T07:55:47-05:00

categories: [Bilberry, Jamstack]
tags: [Sandbox, Development, Testing]
toc: false
author: "Igor Baiborodine"
---

After becoming an official maintainer of the Bilberry theme a few months ago, I was faced with the problem of how to facilitate and speed up the testing of changes submitted by other contributors. 
I felt that just testing in my local dev wasn't enough and that I needed a production-like environment with a website powered by a vanilla Bilberry theme.

Therefore, I created the [Bilberry Sandbox](https://www.bilberry-sandbox.kiroule.com/), which helps me develop, test, and maintain the Bilberry theme. 
So this post details this new testing environment and its use in my development process.

<!--more-->

Using my previously published tutorial ["Start Blogging With Hugo, GitHub and Netlify"](/article/start-blogging-with-github-hugo-and-netlify/), I created a new website and deployed it on Netlify. 
This website is based on the vanilla version of the Bilberry Theme, i.e., it does not contain any customizations. 
The only difference is that it has the raw HTML enabled compared to the example site.

Since I already own the `kiroule.com` domain name, I decided to publish it under the `bilberry-sandbox.kiroule.com` subdomain. 
In the post ["Configure Custom Domain and HTTPS in Netlify: Revisited"](/article/configure-custom-domain-and-https-in-netlify-revisited/), I detailed the configuration differences when using a subdomain for your website to host it on Netlify. 

While configuring site settings on Netlify, I enabled the `Deploy Previews` feature, which allows generating a deploy preview with a unique URL for each built pull request. 
Also, I added the following configuration to the [netlify.toml](https://github.com/igor-baiborodine/bilberry-hugo-theme-sandbox/blob/master/netlify.toml) file:
```toml
[context.deploy-preview]
  command = "hugo -b $DEPLOY_PRIME_URL"
```
Below you will see how this feature can come in handy when testing against a specific fork/branch.
