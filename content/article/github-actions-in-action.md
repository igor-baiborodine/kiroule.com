---
title: "GitHub Actions in Action"
date: 2021-05-07T07:11:44-04:00

categories: ["DevOps", "Write-up"]
tags: ["CICD", "GitHub Actions", "Docker"]
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
The original continuous integration workflow for both projects was implemented using CircleCI. It was an automatic workflow that was executed whenever a commit was pushed to the master branch. Below is the `config.yml` for the `vaadin-demo-bakery-app` repository.

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
      - run: mvn -B com.github.eirslett:frontend-maven-plugin:1.7.6:install-node-and-npm -DnodeVersion="v10.16.0"
      - run: mvn -B clean package -Pproduction
```

#### GitHub Actions - Build
This new automatic workflow replaced the original one, and it differs in that this new workflow is launched not only for every commit to the master branch but also whenever a new pull request to the master is open. Also, instead of using the [frontend-maven-plugin](https://github.com/eirslett/frontend-maven-plugin) plugin to install Node.js and npm, I opted for using the [setup-node]( https://github.com/actions/setup-node) action.

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
This manual workflow allows creating a release for every quarterly source code update. It consists of two jobs: `Tag Release` and `Docker Image`. The `Tag Release` job, based on the [github-tagger](https://github.com/tvdias/github-tagger) action, will mark the release point by tagging the last commit in the master branch. Unlike the Campsite Booking API project, where I used the [Maven Release](https://maven.apache.org/maven-release/maven-release-plugin/) plugin to make a release, here I took a simplified release approach, namely the simple tagging of the master branch.

As for the release versioning, I chose a numbering system based on [Calendar Versioning](https://calver.org/). In addition, the version number is supplemented by the Vaadin version. So, for example, version number `2021.1-14.5` means that the release was made in the spring of 2021, and the Vaadin version used to generate the source code was `14.5`.

The successful completion of the `Tag Release` job is a prerequisite for the `Docker Image` job's subsequent execution when a Docker image is built and published on Docker Hub. The corresponding Dockerfiles can be found [here](https://github.com/igor-baiborodine/vaadin-demo-bakery-app/blob/master/Dockerfile) and [here](https://github.com/igor-baiborodine/vaadin-demo-business-app/blob/master/Dockerfile).

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

The `Release Version` parameter value should be provided before executing the release workflow:

![GitHub Actions Perform Release](/img/content/article/github-actions-in-action/github-actions-perform-release-bakery-app.png)

### Docker Liferay Portal CE
The original continuous delivery workflow was implemented using Travis CI and was executed in the following order:
1. In the local dev, run the `release-image.sh` script for the new version/variant, which will subsequently commit and push the changes to the remote, that is, to GitHub.
2. The new commit to the master will trigger a new job on Travis CI.
3. The job on Travis CI will do the following: \
   &nbsp;&nbsp;&nbsp;&nbsp;-- build a new image \
   &nbsp;&nbsp;&nbsp;&nbsp;-- run tests \
   &nbsp;&nbsp;&nbsp;&nbsp;-- tag and push the new image to Docker Hub \
   &nbsp;&nbsp;&nbsp;&nbsp;-- update README and supported-tags files \
   &nbsp;&nbsp;&nbsp;&nbsp;-- commit and push back changes to GitHub 
4. In the local dev, pull the changes from the remote and repeat step 1 for the next variant.

As you can see, this workflow was not fully automated as I had to go through some manual steps in my local dev. Therefore, when switching to GitHub Actions, the goal was to fully automate the workflow. 

The source code for the Docker Liferay Portal CE project can be found [here](https://github.com/igor-baiborodine/docker-liferay-portal-ce).

#### Travis CI - Release
Below is the original `.travis.yml` file. Every time the `release-image.sh` script was executed in the local dev, the build matrix's `VERSION` and `VARIANT` properties were updated with the supplied values.

```yaml
language: bash
services: docker
branches:
  only:
    master

env:
  global:
  - secure: mAQiO76xNoUi0DQ3NKSx/DonUuWWwq0G3ulCydIeGoyWS74yxQ0IMy+4AwSmP/u08XZlXnyTNiCg1+qpw2C53ZstuCEug/NP8EWnIqMU7UDPOdHNYSbm0T7OuoYiocZFw54ELvHg+qhOdPrYI3aq/04o0F1sGMQH8n+AwHzZcxFH6UZv1XtqmG7nDc+F6+26xdx2OH1p9JajqQK9gtoehH7cpxs8fibT3GKUgwSKM2bvCxvXT1vIYtl1S3TGQu9Pd2mVSpt32HVpgfj5PQyRdfCgBHVCVYszxNW+NrhrjzXgrGr5OPSSAwkcI8R6NT4GtW0N1FDhRLbb1J1eq0W6MhpIHIIKC2NdMo870AgnhUjZ3QqJVG3yfqWpbPOrNi0WqyusRygPWI9lAY6BdmpJwUmNaIP9DdX6LR6Zua+wEuFCVFWr11N/qOc58Do6MfXFAHfbNU0p5LGHAwrjdpJN7+XHyTjgVBbQwYdx3GaRzx0P3VdSfgJVhoCNaKSOCbC/fhgJJfdbKYycLxOIZ9HH39lDs3sw9Yh5MsPgK3oMDsiuG2GmUUz5dpmr3C70+nkeA+YHv6+ScoP2JNIaMqx3cDWABI3B5UvPb+wFAasOmKenIvd082OeUKcFkoAGBRExyOc/J1S5Gc+sDyIlcHy5HSvTDLpvgyNpAbMdGvbV+n8=
  matrix:
    - VERSION=7.3.2-ga3 VARIANT=jdk11-buster

install:
  - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
  - git clone https://github.com/docker-library/official-images.git ~/official-images

before_script:
  - image="$DOCKER_USERNAME/liferay-portal-ce:$VERSION-$VARIANT"
  - latest_image="$DOCKER_USERNAME/liferay-portal-ce:latest"

script:
  - |
    (
      set -Eeuo pipefail
      set -x
      docker build -t "$image" ./"$VERSION/$VARIANT"
      ~/official-images/test/run.sh "$image"
      docker push "$image"
      docker tag "$image" "$latest_image"
      docker push "$latest_image"
      ./script/generate-readme.sh -t "$VERSION/$VARIANT" -c "$TRAVIS_COMMIT"
      git status
    )
after_success:
  - docker images
  - ./script/push-remote.sh
```

#### GitHub Actions - Release
This new `release.yml` file is nothing more than a rewrite of the `.travis.yml`, although there are some minor changes. First, the version and variant values no longer need to be hard-coded as they are provided via a workflow dispatch input. Second, the `release-image.sh` script has been renamed to `release-dockerfile.sh`. And third, the `push-remote.sh` script was included in the `generate-readme.sh` script.

This is a manual workflow, and The `Release Version` parameter value should be provided before executing it. The release version value should follow the `LIFERAY_VERSION/JDK-LINUX_VARIANT` pattern, for example, `7.4.0-ga1/jdk8-alpine`.  The complete release manual can be found [here](https://github.com/igor-baiborodine/docker-liferay-portal-ce/blob/master/readme/release-image-manual.md).

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
  release:
    name: Dockerfile & Docker Image & README
    runs-on: ubuntu-latest
    steps:
      - name: Check out project
        uses: actions/checkout@v2

      - name: Configure Git user
        run: |
          git config user.email "actions@github.com"
          git config user.name "GitHub Actions"

      - name: Release Dockerfile
        run: |
          ./script/release-dockerfile.sh -t "$IMAGE_TAG"

      - name: Check out docker-library/official-images
        run: |
          git clone https://github.com/docker-library/official-images.git ../official-images

      - name: Build image
        run: |
          docker build -t $IMAGE_NAME:"${IMAGE_TAG//\//-}" ./"$IMAGE_TAG"
          ../official-images/test/run.sh $IMAGE_NAME:"${IMAGE_TAG//\//-}"
          docker tag $IMAGE_NAME:"${IMAGE_TAG//\//-}" $IMAGE_NAME:latest

      - name: Log into registry
        run: |
          echo "${{ secrets.DOCKERHUB_TOKEN }}" | docker login -u "${{ secrets.DOCKERHUB_USERNAME }}" --password-stdin

      - name: Push image
        run: |
          docker push $IMAGE_NAME:"${IMAGE_TAG//\//-}"
          docker push $IMAGE_NAME:latest

      - name: Generate README
        run: |
          ./script/generate-readme.sh -t "$IMAGE_TAG" -c "$(git rev-parse HEAD)"
```

Migrating the development workflows of my active projects to GitHub Actions was a great experience, and I learned a lot from the practical side. Now GitHub Actions will be a great addition to my CICD pipeline building skills, which already include Jenkins, Travis CI, Azure DevOps, and Bitbucket Pipelines.
