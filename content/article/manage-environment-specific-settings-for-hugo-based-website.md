---
title: "Manage Environment-Specific Settings for Hugo-Based Website"
date: 2020-07-27T08:48:43-04:00

categories: [Blog, Write-Up]
tags: [Hugo, Configuration, Netlify]
author: "Igor Baiborodine"
summary: 'In this post, I describe how I migrated the configuration of my site from a single config file with placeholders to the Hugo way of managing environment-specific settings, namely the "Configuration Directory" approach. This article is the fifth part of the series "Building Your Blog, the Geeky Way".'
---

Anyone related to software development is familiar with the concept of environments. It all starts with the local development(local) environment, usually a developer's laptop or workstation. That is where most of the coding is done. Then follows the development(dev) environment where you deploy and test results of your work done in the local. Before deploying in the production environment, there are two or three more environments in between, for instance, QA, staging, and/or pre-production. 

Thus, when I started developing my website, I applied this concept of environments. I have three environments: local, dev, and production. I find that these three environments are more than enough when using Hugo, GitHub, and Netlify, even if Netlify allows you to have multiple non-production environments.

In Hugo, to manage your site configuration, you use `config.toml`, `config.yaml`, or `config.json` file, which is found in the site root. You can use the same config file for each of your environments, but it all depends on a Hugo theme you chose for your website. For a minimalistic theme, that could work just fine. But if your theme offers integration with external services such as Google Analytics, Discus or Algolia, using your non-prod environments for development and testing may affect your production environment. For example, using the same Google Analytics ID in local and dev environments will pollute your usage statatistics with data from these non-prod environments.

Since initially I didn't have much experience with Hugo, I solved the problem of managing environment-specific settings by using the placeholder approach. With this approach, you replace in your config.tom file the actual value of configuration setting with a placeholder text, for example:
```toml
googleAnalytics = "GOOGLE_ANALYTICS_ID_PLACEHOLDER"
algolia_indexName = "ALGOLIA_INDEX_NAME_PLACEHOLDER"
```  
 
3. Hugo configuration directory or multiple config files: elaborate
 - ref: https://gohugo.io/getting-started/configuration/#configuration-file
 - proper way to do environment-specific settings configuration - why
 
4. Implementation details:
 - old-config.toml
 - config directory
 - netlify.toml
   