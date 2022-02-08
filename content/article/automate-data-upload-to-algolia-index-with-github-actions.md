---
title: "Automate Data Upload to Algolia Index With GitHub Actions"
date: 2022-02-03T17:56:13-05:00

categories: [Jamstack, Write-Up]
tags: [Algolia, Data Upload, CICD, GitHub Actions]
series: "Building Your Blog, the Geeky Way"
toc: false
author: "Igor Baiborodine"
---

In this post, you will find a ready-made recipe for automating the upload of index records to Algolia using GitHub Actions. 
It complements my previously published ["Automate Data Upload to Algolia Index"](/article/automate-data-upload-to-algolia-index/) and ["Automate Data Upload to Algolia Index: Revisited"](/article/automate-data-upload-to-algolia-index-revisited/) articles.

<!--more-->

Since the advent of the [Bilberry Sandbox](https://www.bilberry-sandbox.kiroule.com/), when compared to my website **kiroule.com**, the only feature it has missed was the automated upload of data to the corresponding Algolia index. 
After successfully deploying the sandbox website on Netlify, I enabled and configured the Algolia search feature by following the [Algolia Indices](/article/automate-data-upload-to-algolia-index/#algolia-indices) and [Configuration Files](/article/automate-data-upload-to-algolia-index/#configuration-files) steps from the ["Automate Data Upload to Algolia Index"](/article/automate-data-upload-to-algolia-index/) tutorial.

Whenever new test content was added, I had to follow the [Manual Upload](https://github.com/Lednerb/bilberry-hugo-theme#manual-upload) procedure from Bilberry theme's README to update Algolia indexes. 
Therefore, the easiest way to solve the automation problem would be to use the same approach I used for the **kiroule.com** website, namely, calling the `algolia/run-data-upload-js.sh` script in the build command in the `netlify.toml` configuration file:
```toml
[context.production]
  command = "hugo --buildFuture && algolia/run-data-upload-js.sh -p"
```

But I'm not the one to follow the path of least resistance.
