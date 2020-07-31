---
title: "Manage Environment-Specific Settings for Hugo-Based Website"
date: 2020-07-27T08:48:43-04:00

categories: [Blog, Write-Up]
tags: [Hugo, Configuration, Netlify]
author: "Igor Baiborodine"
summary: 'In this post, I describe how I migrated the configuration of my site from a single config file with placeholders to the Hugo way of managing environment-specific settings, namely the "Configuration Directory" method. This article is the fifth part of the series "Building Your Blog, the Geeky Way".'
---

In this post, I describe how I migrated the configuration of my site from a single config file with placeholders to the Hugo way of managing environment-specific settings, namely the "Configuration Directory" method. This article is the fifth part of the [series "Building Your Blog, the Geeky Way"](https://www.kiroule.com/article/building-your-blog-the-geeky-way/).

Anyone related to software development or system administration is familiar with the concept of environments. It all starts with the local development(**local**) environment, usually a developer's laptop or workstation. That is where most of the coding is done. Then follows the development(**dev**) environment where you deploy and test results of your work done in the local. Before deploying in the **production** environment, there are two or three more environments in between, for instance, QA, staging, and/or pre-production. 

Thus, when I started developing my website, I applied this concept of environments. I have three environments: local, dev, and production. I find that these three environments are more than enough when using Hugo, GitHub, and Netlify, even if Netlify allows you to have multiple non-production environments.

In Hugo, to manage your site configuration, you use the `config.toml`, `config.yaml`, or `config.json` file, which is found in the site root. You can use the same config file for each of your environments, but it depends on a Hugo theme you chose for your website. For a minimalistic theme, that could work just fine. But if your theme offers integration with external services such as Google Analytics, Discus, or Algolia, using your non-prod environments for development and testing may affect your production environment. For example, using the same Google Analytics ID in local and dev environments will pollute your usage statistics with data from these non-prod environments.

Since I initially didn't have much experience with Hugo, I solved the problem of managing environment-specific settings using the placeholder approach, which was inspired by Netlify's [Inject environment variable values]((https://docs.netlify.com/configure-builds/file-based-configuration/#inject-environment-variable-values)). With this approach, you replace in your `config.toml` file the actual value of configuration setting with a placeholder text, for instance:
```toml
googleAnalytics = "GOOGLE_ANALYTICS_ID_PLACEHOLDER"
algolia_indexName = "ALGOLIA_INDEX_NAME_PLACEHOLDER"
```

To replace these placeholders with actual values that correspond to the environment in question, I created the `config.sh` script:
```shell script
sed -i "s/GOOGLE_ANALYTICS_ID_PLACEHOLDER/${GOOGLE_ANALYTICS_ID}/g" config.toml
sed -i "s/ALGOLIA_INDEX_NAME_PLACEHOLDER/${ALGOLIA_INDEX_NAME}/g" config.toml

grep -E 'googleAnalytics|algolia_indexName' config.toml
```

Provided that the `GOOGLE_ANALYTICS_ID` and `ALGOLIA_INDEX_NAME` environment variables are set accordingly either manually in the local environment or via the `netlify.toml` file for the dev and production environments, the `config.sh` script should be executed right before the `hugo` command:

a) in the local environment 
```shell script
$ ./config.sh && hugo server
```
b) in the dev and production environments
```shell script
$ ./config.sh && hugo
```

So far, this approach served me well. But I recently discovered that Hugo has built-in [functionality](https://gohugo.io/getting-started/configuration/#configuration-directory) for managing environment-specific settings, that is the `Configuration Directory`. It is based on a single site config file that used together with additional configuration files for each environment that placed in the `config` directory in the site root. Since it's considered as the proper way to manage configuration settings for a Hugo-based website, I switched from my custom approach with placeholders to the Hugo's Configuration Directory method.

Now let's look at the implementation details of this migration. The source code is available [here](https://github.com/igor-baiborodine/kiroule.com/releases/tag/configuration-directory).
1. [config/ Directory](#config-directory)
2. [Default Environments](#default-environments)
3. [netlify.toml](#netlifytoml)

### config/ Directory
Since I have local, dev, and production environments, the `config` directory contains one directory for each environment where the `_default` maps to the local environment:

![Config Dir Content](/img/content/article/manage-environment-specific-settings-for-hugo-based-website/config-dir-content.png)

The `_default/config.toml` file here is the same config file that used to be located in the site root, but **without** the `googleAnalytics` and `disqusShortname` settings and the `algolia_indexName` parameter. The `params.toml` file in each environment directory contains only the `algolia_indexName` parameter set to the corresponding value, for example, like in `dev/params.toml`:

```toml
algolia_indexName = "dev_kiroule"
```
The `production/config.toml` contains only the `googleAnalytics` and `disqusShortname` settings.

### Default Environments
As per the Hugo documentation, this is how default environments are chosen when using the `hugo` command:
> Default environments are **development** with `hugo serve` and **production** with `hugo`.

In other words, Hugo implicitly adds `--environment development` and `--environment production` to `hugo serve(r)` and `hugo` commands accordingly. Thus, when you use the `hugo server` command in your local environment, Hugo will use the settings from the `config/_default` directory. And when the `hugo` command is used, Hugo will merge all settings from the `config/production` directory on top of the settings from the `config/_default`. 

### netlify.toml
The following changes have been made to the `netlify.toml` file:
- The `GOOGLE_ANALYTICS_ID` variable was removed from `[context.production.environment]` section.
- Execution of the `config.sh` script was removed from the `command` setting in `[context.dev]` and `[context.production]` sections.
- `--environment dev` option was added to the `hugo` command in the `command` setting in `[context.dev]` section to merge all the settings from the `config/dev` directory on top of the settings from the `config/_default`. 

I had to keep the `ALGOLIA_INDEX_NAME` variable for each environment context since it's needed to execute the `algolia/run-index-upload.sh` script.

This is how the `netlify.toml` file looks like after the above changes:
```toml
[build]
  publish = "public"
  command = "hugo"

# URL: https://kiroule.com/
[context.production.environment]
  HUGO_VERSION = "0.72.0"
  HUGO_ENV = "production"
  HUGO_ENABLEGITINFO = "true"
  # Algolia index name needed to run algolia/run-index-upload.sh
  ALGOLIA_INDEX_NAME = "prod_kiroule"

[context.production]
  command = "hugo --buildFuture && algolia/run-index-upload.sh -p"

# URL: https://dev--kiroule.netlify.app/
[context.dev.environment]
  HUGO_VERSION = "0.72.0"
  # Algolia index name needed to run algolia/run-index-upload.sh
  ALGOLIA_INDEX_NAME = "dev_kiroule"

[context.dev]
  command = "hugo --environment dev -b $DEPLOY_PRIME_URL --buildFuture --buildDrafts && algolia/run-index-upload.sh -p"
```

The source code for the placeholder approach is available [here](https://github.com/igor-baiborodine/kiroule.com/tree/single-config-file).

More articles in this series:  
**[Start Blogging With Hugo, GitHub and Netlify](https://www.kiroule.com/article/start-blogging-with-github-hugo-and-netlify/)**  
**[Configure Custom Domain and HTTPS on Netlify](https://www.kiroule.com/article/configure-custom-domain-and-https-in-netlify/)**  
**[Add Favicon to Hugo-Based Website](https://www.kiroule.com/article/add-favicon-to-hugo-based-website/)**  
**[Automate Index Upload to Algolia Search](https://www.kiroule.com/article/automate-index-upload-to-algolia-search/)**  
