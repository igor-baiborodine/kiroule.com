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
article ["Campsite Booking API: Revisited"](/article/campsite-booking-api-revisited/). During this time, I kept the
project up-to-date and implemented numerous improvements. So, in this article, which is
the second part of
the series ["Campsite Booking API"](/series/campsite-booking-api/), I describe in detail what was achieved and how.

<!--more-->

This project iteration, already the third one, mainly consists of code enhancements. So now let's take a closer
look at it. The source code is
available [here](https://github.com/igor-baiborodine/campsite-booking/tree/v4.3.0).

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

### Local Variables: var Syntax

### Tests: BDD Style and JUnit 5

### 


Continue reading the series ["Campsite Booking API"](/series/campsite-booking-api/):
{{< series "Campsite Booking API" >}}
