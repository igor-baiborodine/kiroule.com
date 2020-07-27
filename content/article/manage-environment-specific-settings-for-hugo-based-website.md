---
title: "Manage Environment-Specific Settings for Hugo-Based Website"
date: 2020-07-27T08:48:43-04:00

categories: [Blog, Write-Up]
tags: [Hugo, Configuration, Netlify]
author: "Igor Baiborodine"
summary: 'TODO'
---

Intro: TODO

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
   