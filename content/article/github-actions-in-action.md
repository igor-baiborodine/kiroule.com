---
title: "GitHub Actions in Action"
date: 2021-04-20T07:11:44-04:00

categories: [CICD, Write-up]
tags: [GitHub Actions, Docker]
toc: false
author: "Igor Baiborodine"
---

After trying to use GitHub Actions for the first time in my Campsite Booking API project, I migrated three more projects to GitHub Actions. In this article, I want to share my experience in automating software development workflows in GitHub repositories.

<!--more-->

Back then, when GitHub couldn't offer full support for CI/CD pipelines, I opted to use the integration services provided by [Travis CI](https://www.travis-ci.com/) and [CircleCI](https://circleci.com/). Therefore, it so happened that the CI workflows for the Vaadin Demo Bakery App and Vaadin Business App projects were implemented using Circle CI, and the CI/CD workflow of the Docker Liferay Portal CE project was implemented with Travis CI. After my first successful experience with GitHub Actions in the  [Campsite Booking API](https://github.com/igor-baiborodine/campsite-booking) repository, I decided to migrate the development workflows of my active projects to GitHub Actions.

{{< toc >}}

### Campsite Booking API
Earlier, I've already described how I replaced Travis CI with GitHub Actions for this project. You can read about that in this [post](/article/campsite-booking-api-revisited/#cicd-workflows).

### Vaadin Demo Apps
I have two GitHub repositories that contain the source code of Vaadin demo applications, namely [Bakery App](https://vaadin.com/docs/v14/guide/starters/bakeryflow/overview) and [Business App](https://vaadin.com/docs/v14/guide/starters/business-app/overview). The source code in these repositories is generated using [Vaadin's App Starter](https://vaadin.com/start). In the past, I used to update the code twice a year when I had time, but this year I decided to make updates and releases on a quarterly basis. The source code for the Bakery and Business applications can be found [here](https://github.com/igor-baiborodine/vaadin-demo-bakery-app) and [here](https://github.com/igor-baiborodine/vaadin-demo-business-app), respectively.

#### CircleCI - Build
The original CI workflow for both projects was implemented using CircleCI. It was an automatic workflow that was executed whenever a commit was pushed to the master branch. Below is the `config.yml` for the `vaadin-demo-bakery-app` repository.

```yaml
version: 2 # use CircleCI 2.0
jobs: 
  build: 
    working_directory: ~/vaadin-demo-bakery-app

    docker: 
      - image: circleci/openjdk:8u171-jdk

    steps: 
      - checkout 
      - restore_cache: 
          key: vaadin-demo-bakery-app-{{ checksum "pom.xml" }}
      - run: mvn dependency:go-offline
      - save_cache:
          paths:
            - ~/.m2
          key: vaadin-demo-bakery-app-{{ checksum "pom.xml" }}
      - run: mvn com.github.eirslett:frontend-maven-plugin:1.7.6:install-node-and-npm -DnodeVersion="v10.16.0"
      - run: mvn package
      - run:
          name: Save test results
          command: |
            mkdir -p ~/test-results/junit/
            find . -type f -regex ".*/target/surefire-reports/.*xml" -exec cp {} ~/test-results/junit/ \;
          when: always
      - store_test_results:
          path: ~/test-results
      - store_artifacts:
          path: ~/test-results/junit 
```

#### GitHub Actions - Build
This automatic workflow replaced the original one, and it differs in that this new workflow is launched not only for every commit to the master branch but also whenever a new pull request to the master is open. Also, instead of using the `frontend-maven-plugin` plugin to install Node.js and npm, I opted for using the [setup-node action]( https://github.com/actions/setup-node).

```yaml
name: Build Project
on:
  pull_request:
    branches:
      - 'master'
  push:
    branches:
      - 'master'
jobs:
  build:
    name: Build Project
    runs-on: ubuntu-latest

    steps:
      - name: Check out project
        uses: actions/checkout@v2

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

      - name: Set up Node.js 14
        uses: actions/setup-node@v2
        with:
          node-version: '14'

      - name: Run Maven Package
        run: mvn -B clean package -Pproduction
```

#### GitHub Actions - Release
```yaml
name: Perform Release
on:
  workflow_dispatch:
    inputs:
      releaseVersion:
        description: Release Version
        required: true
env:
  IMAGE_NAME: ${{ secrets.DOCKERHUB_USERNAME }}/${{ secrets.DOCKERHUB_REPO }}
  IMAGE_TAG:  ${{ github.event.inputs.releaseVersion }}
jobs:
  tag_release:
    name: Tag Release
    runs-on: ubuntu-latest
    steps:
      - name: Check out project
        uses: actions/checkout@v2

      - name: Configure Git user
        run: |
          git config user.email "actions@github.com"
          git config user.name "GitHub Actions"

      - name: Git tag release
        uses: tvdias/github-tagger@v0.0.1
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          tag: ${{ github.event.inputs.releaseVersion }}
  docker_image:
    name: Docker Image
    runs-on: ubuntu-latest
    needs: [ tag_release ]

    steps:
      - name: Check out project
        uses: actions/checkout@v2
        with:
          ref: ${{ github.event.inputs.releaseVersion }}

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

#### Dockerfile - Bakery App
```dockerfile

```
#### Dockerfile - Business App
```dockerfile

```

### Docker Liferay Portal CE
