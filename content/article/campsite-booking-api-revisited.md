---
title: "Campsite Booking API Revisited"
date: 2021-02-03T08:00:01-05:00

categories: [Blog, Write-Up]
tags: [Java, Spring Boot, SonarCloud, GitHub Actions]
toc: false
author: "Igor Baiborodine"
---

The initial task was to develop a Spring Boot based REST API that meets the system requirements outlined in this [README](https://github.com/igor-baiborodine/campsite-booking/blob/master/README.md). In 2019, I switched from Java software development to DevOps and worked in this field for a year and a half. During this period, I mainly developed and maintained CI/CD pipelines using Jenkins and Azure DevOps. So when I came back to this project two years later, the main goal was to complement it from a DevOps perspective, particularly containerization and CI/CD.

Let's look at what was accomplished in more detail.

{{< toc >}}

The source code is available [here](https://github.com/igor-baiborodine/campsite-booking/tree/v2.0.8).

### SonarCloud Scan
Whenever I code, work, or my pet projects, I always strive to produce clean, high-quality code. One of the tools I use to write better and safer code is the SonarLint plugin, which enormously helps in detecting and fixing code smells, bugs, and vulnerabilities while working in IntelliJ.

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
