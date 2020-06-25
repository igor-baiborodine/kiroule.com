---
title: "Multi-Variant Docker Images for Liferay Portal CE"
date: 2020-06-25T06:20:46-04:00

categories: [Containers, Write-Up]
tags: [Docker, Liferay, Debian, Alpine]
author: "Igor Baiborodine"
summary: "TODO"
---

summary: TODO

1. Elaborate on reason d'etre of this project
- Part of preparation for my Docker certification:
-- Dockerfile is a big part of the certification curriculum, therefore additional hands-on experience will not be superfluous
- Why Liferay Portal CE:
-- complex product
-- I have experience working with Liferay
-- Docker image provided by Liferay Inc is only Alpine-based for Java 8 LTS
-- Other limitations: root user execution, impossible override CMD and externalize document library directory 
2. Elaborate on the initial implementation:
- Studied other official images on Docker Hub
- Assumptions: https://github.com/igor-baiborodine/dockerhub-test/blob/master/update-use-cases.md
- Automate image release with a job on Travis CI: travis.yml + auxiliary scripts
- Base tests from Docker Hub for official images
3. Elaborate on this year refactoring:
- Drop support for the slim image
- Explicit version for Debian-based image
- Refactor Dockerfile templates
- Refactor existing and new scripts: dry run functionality and run container script
   
 