---
title: "Campsite Booking API Revisited"
date: 2021-02-03T08:00:01-05:00

categories: [Blog, Write-Up]
tags: [Java, API, Spring Boot, DevOps]
toc: false
author: "Igor Baiborodine"
---

Originally the Campsite Booking API project was a coding challenge for a developer position I applied to at [Upgrade Inc.](https://www.upgrade.com/). Back then, in 2018, the coding challenge was followed by a series of interviews, but in the end, I didn't receive an offer. I recently revisited this project, and in this post, I go over the various improvements and new features that have been implemented.

<!--more-->

The initial task was to develop a Spring Boot based REST API that meets the system requirements outlined in this [README](https://github.com/igor-baiborodine/campsite-booking/blob/master/README.md). In 2019, I switched from Java software development to DevOps and worked in this field for a year and a half. During this period, I mostly developed and maintained CI/CD pipelines using Jenkins and Azure DevOps. So when I came back to this project after two years, the main goal was to complement it from a DevOps perspective, particularly Dockerization and CI/CD pipeline.

Let's look at what was accomplished in more detail.

{{< toc >}}

The source code is available [here](https://github.com/igor-baiborodine/campsite-booking/tree/v2.0.8).

### SonarCloud Scan
TODO

### Code Enhancements
TODO
- Code smells and vulnerabilities
- Test coverage
- Date auditing
- Spring Boot and other dependencies upgrade
- Open API v3 upgrade

### Dockerization
TODO
- Dockerfile
- docker-compose

### CI/CD Pipeline
TODO
- Migrate CI from Travis CI to GitHub Actions
- Integrate GitHub Packages and Docker Hub
