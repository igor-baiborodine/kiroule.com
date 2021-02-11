---
title: "Campsite Booking API Revisited"
date: 2021-02-03T08:00:01-05:00

categories: [Blog, Write-Up]
tags: [Java, Spring Boot, SonarCloud, GitHub Actions, Docker]
toc: false
author: "Igor Baiborodine"
---

The initial task was to develop a Spring Boot based REST API that meets the system requirements outlined in this [README](https://github.com/igor-baiborodine/campsite-booking/blob/master/README.md). In 2019, I switched from Java software development to DevOps and worked in this field for a year and a half. During this period, I mainly developed and maintained CI/CD pipelines using Jenkins and Azure DevOps. So when I came back to this project two years later, the main goal was to complement it from a DevOps perspective, particularly containerization and CI/CD.

Let's look at what was accomplished in more detail.

{{< toc >}}

The source code is available [here](https://github.com/igor-baiborodine/campsite-booking/tree/v2.0.8).

### SonarCloud 
Whenever I code, either work or my pet projects, I always strive to produce clean, high-quality code. One of the tools I use to write better and safer code is the [SonarLint](https://www.sonarlint.org/intellij) plugin, which helps detect and fix code smells, bugs, and vulnerabilities while working in IntelliJ IDEA. 

In case you want to enable continuous code inspections within your development workflow, you can use on-premise [SonarQube](https://www.sonarqube.org/).  Previously, the on-premise option was the only option from [SonarSource](https://www.sonarsource.com/). But they recently offered a cloud-based option called [SonarCloud](https://sonarcloud.io/), which is free for public projects. So I decided to enrich the project's continuous integration workflow with SonarCloud scanning.

For an initial GitHub integration with SonarCloud, you can follow this getting started [guide](https://sonarcloud.io/documentation/integrations/github/). To integrate this Maven-based project, I made the following changes to the [pom.xml](https://github.com/igor-baiborodine/campsite-booking/blob/v2.0.8/pom.xml) file:
1. Added SonarCloud configuration properties:
```xml
<properties>
  <sonar.organization>igor-baiborodine-github</sonar.organization>
  <sonar.projectKey>igor-baiborodine_campsite-booking</sonar.projectKey>
  <sonar.host.url>https://sonarcloud.io</sonar.host.url>
  <sonar.inclusions>src/main/java/**,src/main/resources/**</sonar.inclusions>
  <sonar.issue.ignore.block>generated</sonar.issue.ignore.block>
  <sonar.issue.ignore.block.generated.beginBlockRegexp>@Generated</sonar.issue.ignore.block.generated.beginBlockRegexp>
  <sonar.issue.ignore.block.generated.endBlockRegexp/>
  <sonar.coverage.jacoco.xmlReportPaths>${project.build.directory}/site/jacoco/jacoco.xml</sonar.coverage.jacoco.xmlReportPaths>
</properties>
```
To exclude certain Java classes (like DTOs or model classes) from scanning, you can use a set of `sonar.issue.ignore.block` properties. Excluded classes must be annotated with a `Generated` annotation, for example, `lombok.Generated`, `javax.annotation.processing.Generated` etc.

2. Added `coverage` profile based on the JaCoCo Maven build plugin:
```xml
<profiles>
  <profile>
    <id>coverage</id>
    <build>
      <plugins>
        <plugin>
          <groupId>org.jacoco</groupId>
          <artifactId>jacoco-maven-plugin</artifactId>
          <version>0.8.6</version>
          <executions>
            <execution>
              <id>prepare-agent</id>
              <goals>
                <goal>prepare-agent</goal>
              </goals>
            </execution>
            <execution>
              <id>report</id>
              <goals>
                <goal>report</goal>
              </goals>
            </execution>
          </executions>
        </plugin>
      </plugins>
    </build>
  </profile>
</profiles>
```

After generating an access token in the `Security` section of `My Account` at [sonarcloud.io](https://sonarcloud.io), you can launch the scanning with the following command:
```shell script
$ mvn clean verfify sonar:sonar -Dsonar.login=<SONAR_TOKEN> -Pcoverage
```


### Code Enhancements
TODO
- Code smells and vulnerabilities
- Test coverage
- Date auditing
- Spring Boot and other dependencies upgrade
- Open API v3 upgrade

### Containerization
TODO
- Dockerfile
- docker-compose

### CI/CD
TODO
- Migrate CI from Travis CI to GitHub Actions
- Integrate GitHub Packages and Docker Hub
