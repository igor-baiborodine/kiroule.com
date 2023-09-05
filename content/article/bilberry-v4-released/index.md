---
title: "Bilberry Hugo Theme v4 Released!"
date: 2023-09-05T07:43:00-04:00

categories: ["Bilberry", "Jamstack", "Write-Up"]
tags: ["v4", "Hugo Pipes"]
toc: false
author: "Igor Baiborodine"
---

The long-awaited `v4` of the Bilberry Hugo theme that has been in the works for the last six months is finally released.
The new release is a major version containing a few breaking changes and other essential improvements. In this post, I
shed more light on `v4` features and how they were implemented.

<!--more-->

So, why `v4`? What was the raison d'être of developing a new major version? With the `v3` and previous versions, the
main complaint from the users was that the theme customization, namely applying custom colors and fonts, was rather
inconvenient and cumbersome. The theme's CSS and JavaScript assets management was initially implemented
using [npm](https://www.npmjs.com/) and [Laravel Mix](https://laravel-mix.com/), a Webpack wrapper. To generate the
theme's custom CSS and JavaScript artifacts, you had to execute an `npm` command in your local development environment and
then commit the generated assets to override the ones provided by the theme. Even worse, besides the above, you had to
manage your own theme's fork when importing theme files as a Hugo module.

The solution to this customization issue was switching to Hugo's asset
processing, [Hugo Pipes](https://gohugo.io/hugo-pipes/), which became the main reason for developing the `v4`.

Article plan:
* Why v4?
* Details on what was implemented as per the project scope.

### Details 1
### Details 2
### Details 3


