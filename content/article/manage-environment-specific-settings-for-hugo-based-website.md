---
title: "Manage Environment-Specific Settings for Hugo-Based Website"
date: 2020-07-27T08:48:43-04:00

categories: [Blog, Write-Up]
tags: [Hugo, Configuration, Netlify]
author: "Igor Baiborodine"
summary: 'In this post, I describe how I migrated the configuration of my site from a single config file with placeholders to the Hugo way of managing environment-specific settings, namely the "Configuration Directory" approach. This article is the fifth part of the series "Building Your Blog, the Geeky Way".'
---

In this post, I describe how I migrated the configuration of my site from a single config file with placeholders to the Hugo way of managing environment-specific settings, namely the "Configuration Directory" approach. This article is the fifth part of the series "Building Your Blog, the Geeky Way".

Anyone related to software development or system administration is familiar with the concept of environments. It all starts with the local development(local) environment, usually a developer's laptop or workstation. That is where most of the coding is done. Then follows the development(dev) environment where you deploy and test results of your work done in the local. Before deploying in the production environment, there are two or three more environments in between, for instance, QA, staging, and/or pre-production. 

Thus, when I started developing my website, I applied this concept of environments. I have three environments: local, dev, and production. I find that these three environments are more than enough when using Hugo, GitHub, and Netlify, even if Netlify allows you to have multiple non-production environments.

In Hugo, to manage your site configuration, you use the config.toml, config.yaml, or config.json file, which is found in the site root. You can use the same config file for each of your environments, but it depends on a Hugo theme you chose for your website. For a minimalistic theme, that could work just fine. But if your theme offers integration with external services such as Google Analytics, Discus, or Algolia, using your non-prod environments for development and testing may affect your production environment. For example, using the same Google Analytics ID in local and dev environments will pollute your usage statistics with data from these non-prod environments.

Since I initially didn't have much experience with Hugo, I solved the problem of managing environment-specific settings using the placeholder approach(the source code is available [here](https://github.com/igor-baiborodine/kiroule.com/tree/single-config-file)). With this approach, you replace in your config.toml file the actual value of configuration setting with a placeholder text, for example:
```toml
googleAnalytics = "GOOGLE_ANALYTICS_ID_PLACEHOLDER"
algolia_indexName = "ALGOLIA_INDEX_NAME_PLACEHOLDER"
```

To replace these placeholders with actual values that correspond to the environment in question, I created the config.sh script:
```shell script
sed -i "s/GOOGLE_ANALYTICS_ID_PLACEHOLDER/${GOOGLE_ANALYTICS_ID}/g" config.toml
sed -i "s/ALGOLIA_INDEX_NAME_PLACEHOLDER/${ALGOLIA_INDEX_NAME}/g" config.toml

grep -E 'googleAnalytics|algolia_indexName' config.toml
```

Provided that GOOGLE_ANALYTICS_ID and  ALGOLIA_INDEX_NAME environment variables are set accordingly either manually in the local environment or via the netlify.toml file for the production and dev environments, the config.sh script should be executed right before the hugo command:

a) in the local environment 
```shell script
$ ./config.sh && hugo server
```
b) in the dev and production environments
```shell script
$ ./config.sh && hugo
```

So far, this approach served me well. But I recently discovered that Hugo has built-in [functionality](https://gohugo.io/getting-started/configuration/#configuration-directory) for managing environment-specific settings, that is the `Configuration Directory`. It is based on a single site config file that used together with additional configuration files for each environment that placed in the config directory in the site root. Since it's considered as the proper way to manage configuration settings for a Hugo-based website, I switched from my custom approach with placeholders to the Hugo's Configuration Directory method.

Now let's look at the implementation details of this migration.
1. [config directory](#config-directory)
2. [netlify.toml](#netlifytoml)

### config directory
Since I have local, dev, and production environments, the config directory contains one directory for each environment where the _default maps to the local environment:

![Config Dir Content](/img/content/article/manage-environment-specific-settings-for-hugo-based-website/config-dir-content.png)

The _default/config.toml file here is the same config file used to be in the site root, but **without** the googleAnalytics and disqusShortname settings and the algolia_indexName parameter. The params.toml file in each environment directory contains only the algolia_indexName parameter, which set to the corresponding value, for example, like in dev/params.toml:

```toml
algolia_indexName = "dev_kiroule"
```
The production/config.toml contains only the googleAnalytics and disqusShortname settings.

### netlify.toml
   