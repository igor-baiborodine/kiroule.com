---
title: "Campsite Booking API : Revisited 3"
date: 2023-11-17T06:45:03-05:00

categories: [ "Java", "Write-Up" ]
tags: [ "Spring Boot 3", "API-first design", "Flyway", "EasyRandom", "Test Containers" ]
toc: false
series: [ "Campsite Booking API (Java)" ]

author: "Igor Baiborodine"
---

Another year passed, and I decided to return to this project again and implement a new batch of
improvements. So, continuing the
series ["Campsite Booking API (Java)"](/series/campsite-booking-api-java/) with this installment, I
detail changes to the project and its current state.

<!--more-->

Before I started any development on this iteration, I came up with a list of changes, which I
formalized using
GitHub's [projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/about-projects)
feature. To do so, I created
the [Campsite Booking 2023](https://github.com/users/igor-baiborodine/projects/1/views/1) project
with all the items I wanted to implement. Creating such a project helped me illustrate the scope of
the new iteration, plan my work, and track progress. And now, let's give more details of the most
significant changes.

{{< toc >}}

### Upgrade to Spring Boot 3

Since Spring Boot 3
was [released](https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-3.0-Release-Notes)
almost a year ago, this project was well due for an upgrade from version 2 to version 3. Given that
this project was already using Java 17 LTS, which is the main prerequisite for Spring Boot 3
migration, the upgrade consisted of bumping the version of the `spring-boot-starter-parent` artifact
from `2.7.1` to `3.1.4`. Also, given that Spring Boot 3 moved from Java EE to Jakarta EE APIs for
all dependencies, I had to replace all `javax` imports with `jakarta` ones. Check
this [commit](https://github.com/igor-baiborodine/campsite-booking/commit/c55811131fc34928e084f77e72ae0570e972d882)
for more details.

### Details 2

### Details 3

Continue reading the series ["Campsite Booking API (Java)"](/series/campsite-booking-api-java/):
{{< series "Campsite Booking API (Java)" >}}
