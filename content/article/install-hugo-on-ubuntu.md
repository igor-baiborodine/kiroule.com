---
title: "Install Hugo on Ubuntu"
date: 2021-11-10T08:00:50-05:00

categories: [Jamstack, How-to]
tags: [Hugo, Ubuntu]
toc: false
author: "Igor Baiborodine"
---

In this post, I will show how to install Hugo on Ubuntu in 3 different ways.

<!--more-->

Hugo releases come in two flavors, namely **standard** and **extended**. 
The extended version differs in that it supports SASS/SCSS and PostCSS without any additional tooling or configuration. 
Therefore, you should opt for the extended version if you choose a Hugo theme that doesn't use tools like Webpack for handling SASS/SCSS.

### apt
The first and obvious option would be to use the `APT`, a package-handling utility for Debian and Debian-based Linux distributions.
The following command will install an official [Hugo Debian package](https://packages.debian.org/search?keywords=hugo) which shared with Ubuntu:
```shell
sudo apt-get install hugo
```
But this command is not recommended as it will not install the latest version of Hugo. 
For example, the above command installs `0.68.3/extended` Hugo release, whereas, at the time of writing, the newest version is `0.89.2`. 

### dpkg
To install the latest version of Hugo or a specific one, you can use `dpkg`, the Debian package manager. 
But first, you have to download the `.deb` package from the [official Hugo release page](https://github.com/gohugoio/hugo/releases). 
For example, to install version `0.89.2`, use the following commands:
```shell
wget https://github.com/gohugoio/hugo/releases/download/v0.89.2/hugo_0.89.2_Linux-64bit.deb
sudo dpkg -i hugo_0.89.2_Linux-64bit.deb
```
If you need the extended version, replace `hugo_0.89.2_Linux-64bit.deb` with `hugo_extended_0.89.2_Linux-64bit.deb`.


### snap
