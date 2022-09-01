---
title: "Campsite Booking API : Revisited 2"
date: 2022-09-01T07:53:35-04:00

categories: [Java, Write-Up]
tags: [Java 17, Concurrency, Integration Test, GitHub Actions]
toc: false
series: "Campsite Booking API"
author: "Igor Baiborodine"
---

It has been almost a year and a half since I published the
article ["Campsite Booking API: Revisited"](/article/campsite-booking-api-revisited/). During this time,
I continued to keep it up-to-date and implement numerous improvements. So, in this article, which is the second part of
the series ["Campsite Booking API"](/series/campsite-booking-api/), I describe in detail what was achieved and how.

<!--more-->

List of changes:
Rewrite tests in BDD style using JUnit 5
Switch to var syntax for local variables
Upgrade dependencies and Java to the latest LTS, namely Java 17
Add campsite table, upgrade API to v2
Switch from H2 to Apache Derby
New GitHub action for updating README TOC
Add findForDateRange method without a pessimistic write lock
Add integration tests for concurrent bookings create/update

Intro

{{< toc >}}

### Details 1

### Details 2

### Details 3

* In this article, I want to share my experience in ...
* In this post, I go into detail about ...
* In this post, I go over the various improvements ...
* This post introduces another enhancement ...
* In this post, I will show how to implement ...
* In this post, I describe how I migrated ...
* In this article, I elaborate on ...
* This post summarizes how ...
* In the previous post, I showed you how to ...
* By this post, I start a series ...
* In this post, you will find a ready-made recipe for how to ...
  This article details how to create ...
  In this article, we deepen our understanding ...
  In my last article, I discussed how to set up ...
* This article provides an example of how to create ...
  In this guide, I will walk you through how to make ...
  This article details the steps for creating ...

Continue reading the series ["Campsite Booking API"](/series/campsite-booking-api/):
{{< series "Campsite Booking API" >}}
