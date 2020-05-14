---
title: "Add Favicon to Hugo-Based Website"
date: 2020-05-11T08:19:56-04:00
categories: [Blog]
tags: [Hugo, Favicon]
author: "Igor Baiborodine"
---

In this third article of the series, we continue enhancing the website that we created earlier. This time I will demonstrate to you how to generate a favicon image set and integrate it with a website implemented with Hugo.

<!--more-->

A favicon is a 16x16 pixel-sized image that usually associated with a particular website. In a web browser, favicons most often displayed next to the webpage's title on the tab or the webpage's name in the bookmarks' list. When creating a blog, many underestimate the importance of having a favicon, but it plays an essential role in your website branding and identity around the web.

Looking ahead here is how the favicon, which we create below, will look on a browser's tab:

![Browser Display Favicon in Tab](/img/content/article/add-favicon-to-hugo-based-website/prod-display-favicon.png)

As for adding a favicon to your website, it all depends on how the Hugo theme you have chosen was implemented. Any well-implemented theme should have the `layouts/partial/favicon.html` file where you can define what favicon images to use. This file should be present in the `layouts/partials` folder in your site's root directory. You need to copy the HTML code that was provided by a favicon generator into it:

![Site Directory Layout](/img/content/article/add-favicon-to-hugo-based-website/site-directory-layout.png)

But the presence of the `favicon.html` file in a Hugo theme is not always the case. Then it would help if you looked for the `layouts/partials/head.html` file like that [one](https://github.com/lxndrblz/anatole/blob/master/layouts/partials/head.html). You will have to copy the `head.html` into the `layouts/partials` folder in your site's root directory and replace the favicon's `link` tags with the HTML code provided by a favicon generator.

Next, what's left is to copy all generated favicon images into the `static` folder.

There are two steps in this tutorial:

1. [Add Favicon Using favicon.io](#add-favicon-using-faviconio)
2. [Add Favicon Using realfavicongenerator.net](#add-favicon-using-realfavicongeneratornet)

There are no prerequisites here. You can proceed right to step [2](#add-favicon-using-realfavicongeneratornet) if you already have a base favicon image. If you do not have one and want to create a text-based favicon, you should start at step [1](#add-favicon-using-faviconio). In my case, without pretending to be original, I will use my initials in Russian `ИБ` to create a text-based favicon.

### Add Favicon Using favicon.io

![favicon.io Main View](/img/content/article/add-favicon-to-hugo-based-website/favicon-io-main-view.png)

![favicon.io Generate View](/img/content/article/add-favicon-to-hugo-based-website/favicon-io-generate-view.png)

![favicon.io Generate View Installation](/img/content/article/add-favicon-to-hugo-based-website/favicon-io-generate-view-installation.png)

![favicon.io Zip Extracted Files](/img/content/article/add-favicon-to-hugo-based-website/favicon-io-zip-extracted-files.png)

### Add Favicon Using realfavicongenerator.net

![realfavicongenerator.net Favicon Check](/img/content/article/add-favicon-to-hugo-based-website/realfavicongenerator-main-view-favicon-check.png)

![realfavicongenerator.net Favicon Check Result](/img/content/article/add-favicon-to-hugo-based-website/realfavicongenerator-main-view-favicon-check-result-2.png)

![realfavicongenerator.net Generate Select Image](/img/content/article/add-favicon-to-hugo-based-website/realfavicongenerator-generate-view-select-favicon-image.png)

![realfavicongenerator.net Generate Confirm](/img/content/article/add-favicon-to-hugo-based-website/realfavicongenerator-generate-view-confirm-generate.png)

![realfavicongenerator.net Generate Result](/img/content/article/add-favicon-to-hugo-based-website/realfavicongenerator-generate-view-generate-result.png)

![realfavicongenerator.net Zip Extracted Files](/img/content/article/add-favicon-to-hugo-based-website/realfavicongenerator-zip-extracted-files.png)

![realfavicongenerator.net Commit Diff](/img/content/article/add-favicon-to-hugo-based-website/second-generate-diff-commit.png)

```html
<link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5">
<meta name="msapplication-TileColor" content="#da532c">
<meta name="theme-color" content="#ffffff">
```
![realfavicongenerator.net Prod Display Favicon Top Sites](/img/content/article/add-favicon-to-hugo-based-website/prod-display-favicon-top-sites.png)

### Summary

Continue reading the series:

**Set Up Content Publishing Workflow With Github and Netlify(coming soon)**
