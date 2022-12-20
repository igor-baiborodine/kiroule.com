---
title: "Automate Data Upload to Algolia Index with GitHub Actions"
date: 2022-02-03T17:56:13-05:00

categories: ["Jamstack", "Write-Up"]
tags: ["Algolia", "Data Upload", "CICD", "GitHub Actions"]
series: ["Building Your Blog, the Geeky Way"]
toc: false
author: "Igor Baiborodine"
---

In this post, you will find a ready-made recipe for automating the upload of index records to Algolia using GitHub Actions workflow. 
It complements my previously published ["Automate Data Upload to Algolia Index"](/article/automate-data-upload-to-algolia-index/) and ["Automate Data Upload to Algolia Index: Revisited"](/article/automate-data-upload-to-algolia-index-revisited/) articles.

<!--more-->

Since the advent of the [Bilberry Sandbox](https://www.bilberry-sandbox.kiroule.com/), when compared to my website **kiroule.com**, the only feature it has missed was the automated upload of data to the corresponding Algolia index. 
After successfully deploying the sandbox website on Netlify, I enabled and configured the Algolia search feature by following the [Algolia Indices](/article/automate-data-upload-to-algolia-index/#algolia-indices) and [Configuration Files](/article/automate-data-upload-to-algolia-index/#configuration-files) steps from the ["Automate Data Upload to Algolia Index"](/article/automate-data-upload-to-algolia-index/) tutorial.

Whenever new test content was added, I had to follow the [Manual Upload](https://github.com/Lednerb/bilberry-hugo-theme#manual-upload) procedure from Bilberry theme's README to update Algolia indexes. 
The easiest way to solve the automation issue would be to use the same approach I used for the **kiroule.com** website, namely, calling the `algolia/run-data-upload-js.sh` wrapper script in the build command in the [netlify.toml](https://github.com/igor-baiborodine/kiroule.com/blob/a3462192f1ef123d667906252662cc12dea4a520/netlify.toml) configuration file:
```toml
[context.production]
  command = "hugo --buildFuture && algolia/run-data-upload-js.sh -p"
```

But I'm not the one to follow the path of least resistance. 
Since I gained some experience with GitHub Actions last year while automating software development workflows for my personal projects, I decided to implement a workflow that would upload index data to Algolia on any commit to the master branch, which is mapped to the production environment on Netlify.

So, this [workflow](https://github.com/igor-baiborodine/bilberry-hugo-theme-sandbox/blob/3c77ff2352ca7c5fe5ed460aa5b7df80cd9b03e8/.github/workflows/upload-data-to-algolia-index.yml) is implemented as follows:
```yml
name: Upload Data to Algolia Index

on:
  push:
    branches:
      - master

jobs:
  upload_data:
    runs-on: ubuntu-latest
    steps:
      - name: Git Checkout
        uses: actions/checkout@v2
        with:
          submodules: true  # Fetch Hugo themes (true OR recursive)
          fetch-depth: 0    # Fetch all history for .GitInfo and .Lastmod

      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '14'

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
          # extended: true

      - name: Build Site
        run: hugo

      - name: Upload Data
        working-directory: ./algolia # equivalent of 'cd algolia'
        run: |
          npm install
          npm run data-upload -- -c \
            -f ../public/index.json \
            -a 810O6T2B5U \
            -k ${{ secrets.ALGOLIA_ADMIN_API_KEY }} \
            -n prod_bilberry_sandbox
```

There is nothing complicated in this implementation, and it speaks for itself. 
It all starts with checking out the current repository first, then followed by installing **Node.js** and **Hugo**. 
Next, to generate the `public/index.json` file, the `hugo` command is executed in the `Build Site` step. 
And the last step is the actual upload of data to the Algolia index.

As you can see, the `Upload Data` step is precisely the same as the [Automated Upload](https://github.com/Lednerb/bilberry-hugo-theme#automated-upload) instructions in the theme's README.
The only difference is that the script is invoked with the `-c` or `--clear-index` option, which allows clearing the corresponding Algolia index before starting a new upload.
>1. Switch to the `algolia` directory and install required dependencies by executing the following commands:
>  ```shell script
> cd algolia
> npm install
>  ```
>2. Run the `data-upload.js` from from the `algolia` directory as follows:
>  ```shell script
> npm run data-upload -- \
>     -f ../public/index.json \
>     -a <algolia-app-id> \
>     -k <algolia-admin-api-key> \
>     -n <algolia-index-name>
>  ```

The `algolia-app-id` and `algolia-index-name` placeholders should be replaced with the values of the `algolia_appId` and `algolia_indexName` parameters, respectively, from the [config.toml](https://github.com/igor-baiborodine/bilberry-hugo-theme-sandbox/blob/3c77ff2352ca7c5fe5ed460aa5b7df80cd9b03e8/config.toml) file. 
Since the value of the Algolia's `Admin API Key` must be kept secret, an action secret should be added to the `Secrets` section of the repository's settings. 
The `secrets.ALGOLIA_ADMIN_API_KEY` value will then be used when calling the upload script.

![GitHub Settings | Secrets Section](/img/content/article/automate-data-upload-to-algolia-index-with-github-actions/github-settings-secrets-section.png)

And in conclusion, I want to add that this workflow can be used as-is or combined with other GitHub Actions workflows. 
So, for example, if you plan to use [GitHub Pages](https://pages.github.com/) to host your Bilberry-powered website, the `Upload Data to Algolia Index` action can be used in conjunction with the [GitHub Pages](https://gohugo.io/hosting-and-deployment/hosting-on-github/#build-hugo-with-github-action) action to publish your website. 
