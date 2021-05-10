---
title: "Campsite Booking API: Revisited"
date: 2021-02-03T08:00:01-05:00

categories: [Java, Write-Up]
tags: [Spring Boot, SonarCloud, CICD, GitHub Actions, Docker]
toc: false
author: "Igor Baiborodine"
---

Originally the Campsite Booking API project was a coding challenge for a developer position I applied to at [Upgrade Inc.](https://www.upgrade.com/). Back then, in 2018, the coding challenge was followed by a series of interviews, but in the end, I didn't receive an offer. I recently revisited this project, and in this post, I go over the various improvements and new features that have been implemented.

<!--more-->

The initial task was to develop a Spring Boot-based REST API that meets the system requirements outlined in this [README](https://github.com/igor-baiborodine/campsite-booking/blob/master/README.md). In 2019, I switched from Java software development to DevOps and worked in this field for a year and a half. During this period, I mainly developed and maintained CI/CD pipelines using Jenkins and Azure DevOps. So when I came back to this project two years later, the main goal was to complement it from a DevOps perspective, particularly containerization and CI/CD.

Let's look at what was accomplished in more detail. The source code is available [here](https://github.com/igor-baiborodine/campsite-booking/tree/v2.0.9).

{{< toc >}}

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
$ mvn clean verify sonar:sonar -Dsonar.login=<SONAR_TOKEN> -Pcoverage
```

### Code Enhancements
The SonarCloud scanning revealed some code smells and vulnerabilities. After [fixing](https://github.com/igor-baiborodine/campsite-booking/commit/0bdac033c620b82c2cf22fb353c4907f1ac1c485) code smells, I addressed the main vulnerability, which was detected in the `BookingController` class: persistent entities were used as arguments of `@RequestMapping` methods.  I overlooked this during the initial implementation, and it was [corrected](https://github.com/igor-baiborodine/campsite-booking/commit/46a46a14c45fcbfe307d479948b529c098017bc4) by replacing the `Booking` persistent entity with the `BookingDTO` object. Also, I [improved](https://github.com/igor-baiborodine/campsite-booking/commit/e3720315eac4929a16233fc708cbdd1078bff2dc) the test coverage, which is now at [89.1%](https://sonarcloud.io/component_measures/metric/coverage/list?id=igor-baiborodine_campsite-booking).

Another significant improvement was UUID's introduction for the `Booking` entity while keeping the database's ID. The main advantage here is that entity's unique ID can be created without connecting to the database. You can read more on the pros and cons of using UUID vs. database ID in this Stackoverflow [thread](https://stackoverflow.com/questions/45399/advantages-and-disadvantages-of-guid-uuid-database-keys).

Additionally, the following adjustments were made:
1. [Upgraded](https://github.com/igor-baiborodine/campsite-booking/commit/59f9c2acaee85b1a0a4cebbf08d56dba9f07e51e) Spring Boot and other dependencies
2. [Complemented](https://github.com/igor-baiborodine/campsite-booking/commit/a90bc36f7f89d1fa3d691165334304bd16748a79) the `Booking` entity with date auditing fields
3. [Switched](https://github.com/igor-baiborodine/campsite-booking/commit/d2394601415c1a630c9fe0487e2e05ad13c614ec) to OpenAPI v3

### Containerization
Since deploying applications, especially microservices, using containers has become the de facto standard, I added Dockerfile and Docker Compose files. 

#### Dockerfile
I used a multi-stage build approach to implement the [Dockerfile](https://github.com/igor-baiborodine/campsite-booking/blob/v2.0.8/Dockerfile). With this approach, a Dockerfile consists of different sections or stages, each of which refers to its own base image. 
In my case, the Dockerfile has two stages. The first stage, or builder, is based on the `maven: 3-jdk-11` Docker image. At this point, the project is built and packaged into a JAR artifact using the `mvn package` command. 
 
```dockerfile
FROM maven:3-jdk-11 AS builder

WORKDIR /usr/src/app

COPY . .

RUN mvn --batch-mode package -DskipTests -DskipITs; \
    mv /usr/src/app/target/campsite-booking-$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout).jar \
        /usr/src/app/target/app.jar
```

The second stage is the stage when the actual Campsite Booking API Docker image is built. It's based on OpenJDK's `buster-slim` image.

```dockerfile
FROM openjdk:11-jre-slim

ENV APP_HOME /opt/campsite
ENV APP_USER campsite
ENV APP_GROUP campsite

RUN groupadd ${APP_GROUP}; \
    useradd -g ${APP_GROUP} ${APP_USER}

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        # su tool for easy step-down from root
        gosu; \
    rm -rf /var/lib/apt/lists/*; \
    gosu nobody true

COPY --from=builder --chown=${APP_USER}:${APP_GROUP} /usr/src/app/target/app.jar ${APP_HOME}/app.jar
COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

WORKDIR ${APP_HOME}
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 8080
CMD ["bash", "-c", "java -jar $APP_HOME/app.jar"]
```

When building the image, the user that will be used to run the image defaults to `root`. The step-down from `root` to a non-privileged user `campsite` is done during the execution of the [docker-entrypoint.sh](https://github.com/igor-baiborodine/campsite-booking/blob/v2.0.8/docker-entrypoint.sh).
```shell script
if [[ "$3" == java* && "$(id -u)" = '0' ]]; then
  echo "Switching user from root to $APP_USER..."
  chown -R "$APP_USER:$APP_GROUP" "$APP_HOME"
  exec gosu "$APP_USER" "$@"
fi
```

#### Docker Compose

The Docker Compose [file](https://github.com/igor-baiborodine/campsite-booking/blob/v2.0.8/docker-compose.yml) consists of two services.  The `db` service is based on the `mysql:5.7` Docker image. Since its configuration contains the  `./mysql/initdb.d:/docker-entrypoint-initdb.d` volume definition, the `mysql/initdb.d/init-campsite-db.sql` file will be executed when a container starts for the first time. This script creates the `campsite` database and the `campsite` user with all necessary privileges. The database data is stored outside of the container since the `/var/lib/mysql` directory is mapped to the named volume `db-data` defined in the `volumes` section.

```yaml
db:
  image: mysql:5.7
  environment:
    # Setting this variable to yes is not recommended
    # unless you really know what you are doing
    - MYSQL_ALLOW_EMPTY_PASSWORD=yes
  ports:
    - "3316:3306"
    - "33070:33060"
  volumes:
    - db-data:/var/lib/mysql
    - ./mysql/conf.d:/etc/mysql/conf.d
    - ./mysql/initdb.d:/docker-entrypoint-initdb.d
```

The `api` service is based on the build context, which is the project's root. Alternatively, you can use an [image](https://hub.docker.com/r/ibaiborodine/campsite-booking) published on Docker Hub, for example, `ibaiborodine/campsite-booking:latest`. To do this, comment out the `build` config option and uncomment the `image` option.

```yaml
api:
  build: .
  # image: ibaiborodine/campsite-booking:latest
  depends_on:
    - db
  environment:
    # sleep for 20 seconds while the database is being initialized
    - WAIT_FOR_DB=20
    - SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/campsite?useUnicode=true
  ports:
    - "80:8080"
```

Since the `depends_on` option does not wait for the `db` service to be ready, that is, when the `campsite` database and `campsite` user are initialized, I added a delay that is configurable through the `WAIT_FOR_DB` environment variable. The wait is triggered by the following condition in the docker-entrypoint.sh:

```shell script
if [[ -n "$WAIT_FOR_DB" ]]; then
  echo "Sleeping for $WAIT_FOR_DB seconds while the database is being initialized..."
  sleep "$WAIT_FOR_DB"
fi
```

### CI/CD Workflows
The original CI workflow was implemented using [Travis CI](https://www.travis-ci.com), a hosted continuous integration service. This workflow was relatively straightforward and only consisted of executing the `mvn clean integration-test` command triggered by any commit on the `master` branch.
```yaml
language: java

jdk:
- openjdk11

script: mvn clean integration-test

notifications:
  email: false
```

So far, I have had experience developing pipelines using Jenkins, Travis CI, Azure DevOps, and Bitbucket Pipelines. Since 2019, GitHub offers support for full-fledged CI/CD pipelines, free for public repositories. Therefore, I decided to use GitHub Actions for re-implementing the project's CI/CD.

For this project, I adopted the [trunk-based development](https://trunkbaseddevelopment.com/) as a source-control branching model. With this model, all development is done either by committing directly to the trunk or through short-lived feature branches merged to the trunk using pull requests combined with the automated builds. Also, the master branch is meant to be deployable at any commit. With all this in mind, I developed the following GitHub Action workflows: [Build Master Branch](https://github.com/igor-baiborodine/campsite-booking/actions/workflows/master.yml), [Build on Pull Request](https://github.com/igor-baiborodine/campsite-booking/actions/workflows/pull-request.yml), and [Perform Release](https://github.com/igor-baiborodine/campsite-booking/actions/workflows/release.yml).

![GitHub Actions Main View](/img/content/article/campsite-booking-api-revisited/github-actions-main-view.png)

#### Pull Request
This is an automatic workflow that starts whenever a new pull request is made to the master branch. It contains two jobs: Unit & Integration Tests and SonarCloud Scan. The SonanCloud Scan job is dependent on the successful completion of the Unit & Integration Tests job.
```yaml
name: Build on Pull Request

on:
  pull_request:
    branches:
      - 'master'

jobs:
  test:
    name: Unit & Integration Tests
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v1

      - name: Cache local Maven repository
        uses: actions/cache@v2
        with:
          path: ~/.m2/repository
          key: ${{ runner.os }}-maven-${{ hashFiles('**/pom.xml') }}
          restore-keys: ${{ runner.os }}-maven-

      - name: Set up JDK 11
        uses: actions/setup-java@v1
        with:
          java-version: 11

      - name: Run Maven Verify
        run: mvn -B clean verify 

  sonar:
    name: SonarCloud Scan
    runs-on: ubuntu-latest
    needs: [ test ]

    steps:
      - uses: actions/checkout@v1

      - name: Set up JDK 11
        uses: actions/setup-java@v1
        with:
          java-version: 11

      - name: Run SonarCloud scan
        run: mvn -B clean verify sonar:sonar -Pcoverage -Dsonar.login=${{ secrets.SONAR_TOKEN }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

#### Master Branch
This is also an automatic workflow, and it runs whenever a commit is pushed to the master branch. It contains the Snapshot Publishing job, which will package a snapshot JAR and upload it to the GitHub Packages, and the SonarCloud job.
```yaml
name: Build Master Branch

on:
  push:
    branches:
      - 'master'

jobs:
  jobs:
  sonar:
    name: SonarCloud Scan
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v1

      - name: Set up JDK 11
        uses: actions/setup-java@v1
        with:
          java-version: 11

      - name: Run SonarCloud scan
        run: mvn -B clean verify sonar:sonar -Pcoverage -Dsonar.login=${{ secrets.SONAR_TOKEN }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  
  snapshot:
    name: Snapshot Publishing
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v1

      - name: Set up JDK 11
        uses: actions/setup-java@v1
        with:
          java-version: 11

      - name: Publish snapshot on GitHub Packages
        run: mvn -B clean deploy -DskipTests
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

#### Release
This is a workflow that is triggered manually whenever the code in the master branch is ready to be released. It contains two jobs: Maven Release and Docker Image. The Maven Release job performs a release and uploads produced release JAR to GitHub Packages. Its successful completion is a prerequisite for the Docker Image job's subsequent execution when the Docker image is built and uploaded to [Docker Hub](https://hub.docker.com/r/ibaiborodine/campsite-booking).
```yaml
name: Perform Release
on:
  workflow_dispatch:
    inputs:
      releaseVersion:
        description: Release Version
        required: true

env:
  IMAGE_NAME: ${{ secrets.DOCKERHUB_USERNAME }}/campsite-booking
  IMAGE_TAG:  ${{ github.event.inputs.releaseVersion }}

jobs:
  maven_release:
    name: Maven Release
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Cache local Maven repository
        uses: actions/cache@v2
        with:
          path: ~/.m2/repository
          key: ${{ runner.os }}-maven-${{ hashFiles('**/pom.xml') }}
          restore-keys: ${{ runner.os }}-maven-

      - name: Set up JDK 11
        uses: actions/setup-java@v1
        with:
          java-version: 11
          server-id: github

      - name: Configure Git user
        run: |
          git config user.email "actions@github.com"
          git config user.name "GitHub Actions"

      - name: Perform release & publish artifacts
        run: ./mvnw -B release:prepare release:perform -DreleaseVersion=${{ github.event.inputs.releaseVersion }} -DskipTests -DskipITs
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  docker_image:
    name: Docker Image
    runs-on: ubuntu-latest
    needs: [ maven_release ]

    steps:
      - uses: actions/checkout@v2
        with:
          ref: v${{ github.event.inputs.releaseVersion }}

      - name: Build image
        run: |
          docker build . --file Dockerfile --tag $IMAGE_NAME:$IMAGE_TAG
          docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest

      - name: Log into registry
        run: echo "${{ secrets.DOCKERHUB_TOKEN }}" | docker login -u "${{ secrets.DOCKERHUB_USERNAME }}" --password-stdin

      - name: Push image
        run: |
          docker push $IMAGE_NAME:$IMAGE_TAG
          docker push $IMAGE_NAME:latest
```

The `Release Version` parameter value should be provided before executing this workflow:
![GitHub Actions Perform Release](/img/content/article/campsite-booking-api-revisited/github-actions-perform-release.png)

And in conclusion, I want to say that coming back to the project after two years and working on it again was quite refreshing and enjoyable. After improving the existing code base and adding new features such as containerization and CI/CD, the project is now more robust and complete.