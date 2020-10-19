---
title: "Add Table of Contents to Hugo Theme"
date: 2020-10-19T08:08:54-04:00
draft: false
categories: [Theme, Recipe]
tags: [Hugo, TOC]
series: "Hugo Theme Recipes"
toc: false
author: "Igor Baiborodine"
---

This post introduces another enhancement to a Hugo theme - the Table of Contents (TOC). It's based on Hugo's built-in ability to parse Markdown content and generate a table of contents that can be used in templates. This article is the second in the "Hugo Theme Recipes" series.

<!--more-->

Usually, my tutorials or write-ups start with an introductory part. Then follows either detailed steps or implementation details, where each section is headed with an H3(`###`) heading. To make navigation easier within my articles, right after the introductory part, I add a list of anchor links to the sections below; for instance, a link `[Install Hugo](#install-hugo)` will correspond to a section headed with `### Install Hugo`. Such a list is nothing but a table of contents.

Instead of manually adding a list of anchor links, I wanted to automate the table of contents creation. 