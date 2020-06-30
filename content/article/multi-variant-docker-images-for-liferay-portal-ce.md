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

Back then, I worked a lot with Liferay Portal, which is an open-source portal framework for building web applications, websites, and portals. It is a non-trivial software product, and I thought implementing a Dockerfile to create an image and run it in a container would be a good practice in addition to my exam preparations. After checking Docker Hub for any images for Liferay Portal Community Edition, I found that the [one provided by Liferay Inc.](https://hub.docker.com/r/liferay/portal) is only available in Java 8 and is based on Alpine Linux. 

Before I started implementing anything, I spent a considerable amount of time studying Dockerfile implementations of [official images](https://hub.docker.com/search?q=&type=image&image_filter=official) published by Docker, such as [Redis](https://github.com/docker-library/redis), [Tomcat](https://github.com/docker-library/tomcat), [MariaDB](https://github.com/docker-library/mariadb), and [RabbitMQ](https://github.com/docker-library/rabbitmq). I also looked at how official images published by **Docker** since I wanted to automate the process of publishing images to Docker Hub using a continuous integration service like [Travis CI](https://travis-ci.org/) or [CircleCI](https://circleci.com/).

The [initial implementation](https://github.com/igor-baiborodine/docker-liferay-portal-ce/tree/V2019) meant supporting the following:
- Liferay Portal major version: **7**
- Liferay Portal release: **only the latest GA**
- Two latest JDK LTS versions:  **8**, **11**
- Latest Linux variants: **Alpine**, **Debian Stretch**, **Debian Stretch Slim**

The image release workflow was based on the following assumptions:
- All Dockerfile variants are released in the `master` branch.
- Only a single Dockerfile variant is released at once.
- Any release pushed to the `origin/master` on GitHub should trigger a build job on Travis CI.

The build job on Travis CI was supposed to:
- Build a Docker image from the released Dockerfile variant.
- Test the newly built image using Docker's [official images test suite](https://github.com/docker-library/official-images/tree/master/test).  
- Push the image to Docker Hub.
- Generate updated project's `README`.
- Push the newly generated `README` to the `origin/master` on GitHub.

To facilitate the implementation and debugging of Travis CI and Docker Hub integration, I created an auxiliary [project](https://github.com/igor-baiborodine/dockerhub-test). 

Working in my spare time, it took me almost eight weeks to implement Dockerfile templates, auxiliary shell scripts, and the image release pipeline. The first images were released on July 3rd, 2019, and it was for version 7.1.3-ga4. Since then, I had continued publishing new images on Docker Hub for each GA version. 

But almost a year later, I decided to revise the project and see what could be improved. First of all, the support for Debian's `slim` variants was dropped due to the total image size (more than 1 GB) and the fact that the `slim` variant contains only the minimal packages to run Java. That entailed the refactoring of Dockerfile templates. As a result, three distinct templates were refactored into one base template with two template partials (one for each variant). Secondly, I added a dry-run functionality to release an image and, consequently, update the `README` file. Thirdly, all test commands to run containers were combined and finalized into one single script. And last but not least, the image naming convention was updated to include the current stable release codename for the Debian-based variant(`buster` at the moment of writing).   

Summing up, this project was a good exercise that helped me gain hands-on experience. It was an excellent supplement to my preparations for the Docker certification exam, which I successfully [passed](https://credentials.docker.com/efc0806a-b47a-488e-955b-43695a823864#gs.91vgbj) on August 5, 2019.

[See Docker Hub Repository](https://hub.docker.com/r/ibaiborodine/liferay-portal-ce)  
[See GitHub Repository](https://github.com/igor-baiborodine/docker-liferay-portal-ce)
