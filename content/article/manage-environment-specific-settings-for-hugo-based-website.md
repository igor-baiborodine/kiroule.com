---
title: "Manage Environment-Specific Settings for Hugo-Based Website"
date: 2020-07-27T08:48:43-04:00

categories: [Blog, Write-Up]
tags: [Hugo, Configuration, Netlify]
author: "Igor Baiborodine"
summary: 'In this post, I describe how I migrated the configuration of my site from a single config file with variable placeholders to the Hugo way of managing environment-specific settings, namely the "Configuration Directory" approach. This article is the fifth part of the series "Building Your Blog, the Geeky Way".'
---

Anyone related to software development is familiar with the concept of environments. It all starts with the local development(local) environment, usually a developer's laptop or workstation. That is where most of the coding is done. Then follows the development(dev) environment where you deploy and test results of your work done in the local. Before deploying in the production environment, there are two or three more environments in between, for instance, QA, staging, and/or pre-production. 

So when I started developing my website, I applied this concept of environments. I use three environments: local, dev, and production. I find that the three environments are more than enough when using Hugo, GitHub, and Netlify, even though Netlify allows you to have multiple non-production environments.

1. Classic single file configuration + disadvantages:
 - Google Analytics ID - pollute stats if not configured
 - Algolia search config by environment: same index for any environment, e.g.,  local dev and production
 - Discus is enabled in non-prod environments  

2. Describe single configuration file implementation with placeholders:
 - placeholders in the config.toml file
 - config.sh to replace placeholders for each environment 
 - command in netlify.toml
 - disadvantages: Discus is enabled in non-prod environments
 
3. Hugo configuration directory or multiple config files: elaborate
 - ref: https://gohugo.io/getting-started/configuration/#configuration-file
 - proper way to do environment-specific settings configuration - why
 
4. Implementation details:
 - old-config.toml
 - config directory
 - netlify.toml
   