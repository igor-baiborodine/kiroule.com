---
title: "Start Blogging With GitHub, Hugo and Netlify"
date: 2020-04-26T19:47:04-04:00
categories: [tutorial]
tags: [blog, github, hugo, netlify]
author: "Igor Baiborodine"
---

By this blog post, I start a series of articles where I share my experience in how to start a journey as a blogger from a technical perspective. This tutorial will show you how to set up from scratch a blog using GitHub, Hugo and Netlify.

<!--more-->

So, you decided to start blogging, and you need to set up a blog. But from where to start? It all depends on your technical skillset. If you are not a geeky person, maybe a better approach would be to use such blogging platforms as [WordPress.com](https://wordpress.com/create-blog/) or [Wix.com](https://www.wix.com/start/blog). But if you are skilled in software development or any other related field, creating your blog with GitHub, Hugo and Netlify is the way to go.  What are the advantages of using the GitHub-Hugo-Netlify combination? 

First of all, to create content, you will use Markdown, a lightweight markup language. It offers a simple formatting syntax and cross-platform portability. Also, you can use pure HTML within content written in Markdown. 

Secondly, all your website content will be built with [Hugo](https://gohugo.io/), an open-source static site generator. It provides excellent performance, numerous out-of-the-box features, fast built-in server reloads and plenty of [themes](https://themes.gohugo.io/) to choose from.

Thirdly, using Netlify to deploy and host websites is simple and straightforward. Netlify offers a free tier plan, which is more than enough for any static website implemented with GitHub and Hugo.  Netlify's Continuous Deployment feature, in conjunction with GitHub, substantially helps in automating the content publishing workflow.

But enough talk, let's get started. The tutorial below consist of the following steps:
1. [Install Hugo](#install-hugo)
2. [Create New Site](#create-new-site)
3. [Customize Example Site](#customize-example-site)
4. [Create About Page](#create-about-page)
5. [Push Git Repository to GitHub](#push-git-repository-to-github)
6. [Deploy on Netlify](#deploy-on-netlify)

Among the prerequisites for this tutorial is a basic knowledge of Git with its command-line interface and GitHub/Netlify accounts. As a host operating system, I will be using Ubuntu 18.04.

### Install Hugo
As per [Hugo's official documentation](https://gohugo.io/getting-started/installing/#debian-and-ubuntu), using `sudo apt-get install hugo` command is not recommended because it will not install the latest version of Hugo. Indeed, you will get version `0.40.1` while the newest version at the moment of writing is `0.69.1`. Therefore, download a .deb package from the [official Hugo releases page](https://github.com/gohugoio/hugo/releases) and install it using `dpkg` utility:

```plaintext
$ wget https://github.com/gohugoio/hugo/releases/download/v0.69.1/hugo_0.69.1_Linux-64bit.deb
$ sudo dpkg -i hugo_0.69.1_Linux-64bit.deb
```
![Hugo Version Manual Install](/img/content/article/start-blogging-with-github-hugo-and-netlify/hugo-version-manual-install.png)

### Create New Site
To create a new site in the provided directory, use `hugo new site [path]` command, e.g.:
```plaintext
$ hugo new site kiroule.com
```
Here, I use `kiroule.com` as a site name since I already own this domain name, and I'm planning to set it up as a custom domain for my website. The newly created site has the correct structure but without any content or theme.

![Hugo New Site](/img/content/article/start-blogging-with-github-hugo-and-netlify/hugo-new-site.png)

Before proceeding any further, you need to choose a Hugo theme. Hugo offers a [plethora of themes](https://themes.gohugo.io/) that suit different tastes and needs. I picked [Bilberry Hugo](https://themes.gohugo.io/bilberry-hugo-theme/) theme because it is suitable for blogging, responsive and multilingual. Also, it offers support for Disqus comments, Algolia search and Google Analytics.

Move to the site directory and initialize a Git repository:
```plaintext
$ cd kiroule.com
$ git init
```

Then move to `themes` directory and add the theme in question as a Git submodule:
```plaintext
$ cd themes
$ git submodule add https://github.com/Lednerb/bilberry-hugo-theme.git
```

The `git submodule add` allows cloning of the theme repository to your project and keeping it as a subdirectory of the site repository. Also, it permits Netlify to recursively clone the site repository along with the theme repository when building and deploying the site.

Copy the content of `themes/bilberry-hugo-theme/exampleSite` directory to the site directory, remove the default archetype and move back to the site directory:
```plaintext
$ cp -r bilberry-hugo-theme/exampleSite/* ../
$ rm ../archetypes/default.md
$ cd ..
```

At this point, the site directory structure should look like below, where  `content` directory contains the content from the example site:

![Hugo New Site Dir Structure](/img/content/article/start-blogging-with-github-hugo-and-netlify/hugo-new-site-dir-structure.png)

From the site directory, start the hugo server to build and serve the site:

![Hugo New Site Serve](/img/content/article/start-blogging-with-github-hugo-and-netlify/hugo-new-site-serve.png)

Access the site in your browser at http://localhost:1313. As you can see, the new site is simply a copy of the example site provided by the theme. 

![Hugo New Site Browser](/img/content/article/start-blogging-with-github-hugo-and-netlify/hugo-new-site-browser.png)

### Customize Example Site
After making sure that the site can be built and served, let's proceed with customizations. To do so, you need to configure settings according to your needs in `config.toml` file, which Hugo uses as the default website configuration file. Please see [Hugo documentation](https://gohugo.io/getting-started/configuration/) for more details on all available configuration settings. 

Here is a [version](https://github.com/igor-baiborodine/kiroule.com/blob/2cdf8876cff62fce786c3f1fb7795cd32402f0da/config.toml
) of `config.toml` file after applying the following changes:

TODO: list and explain the changes

### Create About Page
TODO
### Push Git Repository to GitHub
TODO
### Deploy on Netlify
