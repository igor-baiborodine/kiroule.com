---
title: "Multi-Variant Docker Images for Liferay Portal Community Edition"
date: 2020-06-25T06:20:46-04:00

categories: [Containers, Write-Up]
tags: [Docker, Liferay, Debian, Alpine]
author: "Igor Baiborodine"
summary: "In this article, I elaborate on my personal project, which was part of preparations for the Docker Certified Associate exam. You will be presented with detailed information about the initial implementation and some refactorings that have been done recently."
---

It's been almost a year since I became a [Docker Certified Associate](https://credentials.docker.com/efc0806a-b47a-488e-955b-43695a823864). As with any certification, I consider it a good starting point to learn new technology. Of course, nothing can beat hands-on experience, but to pass a certification exam, you must learn fundamentals that you can later apply in practice.

One of the main parts of the [Docker certification curriculum](https://docker.cdn.prismic.io/docker/4a619747-6889-48cd-8420-60f24a6a13ac_DCA_study+Guide_v1.3.pdf) is image creation and management. Therefore, I decided not to limit myself to merely memorizing the [Dockerfile reference](https://docs.docker.com/engine/reference/builder/), but to practice creating a Dockerfile, not just a banal `Hello, World!` but something more complex and practical.

Back then, I worked a lot with Liferay Portal, which is an open-source portal framework for building web applications, websites, and portals.
It is a non-trivial product, and I thought implementing a Dockerfile to create an image and run it in a container would be a good practice in addition to my exam preparations. After checking Docker Hub for any images for Liferay Portal Community Edition, I found that the [one provided by Liferay Inc.](https://hub.docker.com/r/liferay/portal) is only available in Java 8 and is based on Alpine Linux. 

Before I started implementing anything, I spent a considerable amount of time studying Dockerfile implementations of [official images](https://hub.docker.com/search?q=&type=image&image_filter=official) published by Docker, such as [Redis](https://github.com/docker-library/redis), [Tomcat](https://github.com/docker-library/tomcat), [MariaDB](https://github.com/docker-library/mariadb), and [RabbitMQ](https://github.com/docker-library/rabbitmq). I also looked at how official images published by **Docker** since I wanted to automate the process of publishing images to Docker Hub using a continuous integration service like [Travis CI](https://travis-ci.org/) or [CircleCI](https://circleci.com/).


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
   
 