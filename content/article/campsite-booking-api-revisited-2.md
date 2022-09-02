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

This project iteration, already the third one, mainly consists of code enhancements. So now, let's take a closer look at
it in the order in which they were added. The source code is
available [here](https://github.com/igor-baiborodine/campsite-booking/tree/v4.3.0).

{{< toc >}}

### Tests with JUnit 5 in BDD style

### var Syntax for Local Variables

### Java 17

### Campsite Table, API v2

### Apache Derby Instead of H2

### findForDateRange Method without Pessimistic Write Locking

### Integration Tests for Concurrent Booking Create/Update

### README TOC GitHub Action

Continue reading the series ["Campsite Booking API"](/series/campsite-booking-api/):
{{< series "Campsite Booking API" >}}
