---
title: "Simplify Development and Testing With Bilberry Sandbox"
date: 2022-01-20T07:55:47-05:00

categories: [Bilberry, Jamstack, Write-Up]
tags: [Sandbox, Development, Testing]
toc: false
author: "Igor Baiborodine"
---

After becoming an official maintainer of the Bilberry theme a few months ago, I was faced with the problem of how to facilitate and speed up the testing of changes submitted by other contributors. 
I felt that just testing in my local dev wasn't enough and that I needed a production-like environment with a website powered by a vanilla Bilberry theme.

Therefore, I created the [Bilberry Sandbox](https://www.bilberry-sandbox.kiroule.com/), which helps me develop, test, and maintain the Bilberry theme. 
So this post details this new testing environment and its use in my development process.

<!--more-->

Using my previously published tutorial ["Start Blogging With Hugo, GitHub and Netlify"](/article/start-blogging-with-github-hugo-and-netlify/), I created a new website and deployed it on Netlify. 
This website is based on the vanilla version of the Bilberry Theme, i.e., it does not contain any customizations. 
The only difference is that it has the raw HTML enabled compared to the example site.

Since I already own the `kiroule.com` domain name, I decided to publish it under the `bilberry-sandbox.kiroule.com` subdomain. 
In the post ["Configure Custom Domain and HTTPS in Netlify: Revisited"](/article/configure-custom-domain-and-https-in-netlify-revisited/), I detailed the configuration differences when using a subdomain for your website to host it on Netlify. 

While configuring site settings on Netlify, I enabled the [Deploy Previews](https://docs.netlify.com/site-deploys/deploy-previews/) feature, which allows generating a deploy preview with a unique URL for each built pull request. 
Also, I added the following configuration to the [netlify.toml](https://github.com/igor-baiborodine/bilberry-hugo-theme-sandbox/blob/master/netlify.toml) file:
```toml
[context.deploy-preview]
  command = "hugo -b $DEPLOY_PRIME_URL"
```
Below you will see how this feature can come in handy when testing against a specific fork/branch.

### Test Against Fork/Branch

So here is my routine when I need to test pull requests from other contributors.
The first thing to do is to create a new test branch in the local `bilberry-hugo-theme-sandbox` repository. 
Then the `url` configuration variable in the `.gitmodules` file must be updated with the URL of the fork in question. 
The `branch` variable should also be defined if the submitted changes are in a specific branch. 
The updated `.gitmodules` file might look like this:
```shell
[submodule "themes/bilberry-hugo-theme"]
  path = themes/bilberry-hugo-theme
  url = https://github.com/TeknikalDomain/bilberry-hugo-theme.git
  branch = peertube-video
```

Next, the theme submodule needs to be synced and updated using the following commands:
```shell
$ git submodule sync
$ git submodule update --init --recursive --remote
```

And only now we can start testing. 
I usually create test content for each use case, which is categorized and tagged accordingly. 
So, for example, while testing the ["Support for custom audio files"](https://github.com/Lednerb/bilberry-hugo-theme/issues/270) issue, all the test content I created was categorized as `Audio`, and each article was tagged according to the tested use case, namely the supported audio streaming providers: `Mixcloud`, `SoundCloud`, `Spotify`, and `TuneIn`.
With proper categorization and tagging, it's easy to filter the necessary content, for instance, https://www.bilberry-sandbox.kiroule.com/categories/audio/ or https://www.bilberry-sandbox.kiroule.com/tags/spotify/.

Then after deploying the Bilberry Sandbox website in my local dev with the `hugo server` command, I test the newly created content. 
If the test results are satisfactory, I commit and push the test branch to remote.

The next step is to create a pull request for the new branch in the [bilberry-hugo-theme-sandbox](https://github.com/igor-baiborodine/bilberry-hugo-theme-sandbox) repository on GitHub.
Given that **Deploy Previews** is enabled for this repository, Netlify automatically builds the website from that branch and deploys it to a unique URL.
Upon successful deployment, the Netlify bot updates the pull request with a comment which may look as follows:

![Netlify Bot Comment Deploy Preview](/img/content/article/simplify-development-and-testing-with-bilberry-sandbox/deploy-preview-netlify-bot-comment.png)

As you can see, this comment includes the deploy preview URL, which is prefixed by `deploy-preview` and followed by the identifier number of the pull request.
The website published to this URL will be updated each time changes are made to the corresponding pull request.

Then again, I verify the deployed test content, but this time I'm testing it in a production-like environment. 
If I get the expected results, I can approve changes (pull request) from other contributor's fork/branch and merge it into the `master` branch of the [bilberry-hugo-theme](https://github.com/Lednerb/bilberry-hugo-theme) repository.

Following the successful merge, the test branch I created in the [bilberry-hugo-theme-sandbox](https://github.com/igor-baiborodine/bilberry-hugo-theme-sandbox) repository also needs to be merged into the master. 
But before that, in my local dev, the `.gitmodules` file needs to be rolled back to the state when the branch was created, i.e., the `url` variable should match the URL of the original repository:
```shell
[submodule "themes/bilberry-hugo-theme"]
  path = themes/bilberry-hugo-theme
  url = https://github.com/Lednerb/bilberry-hugo-theme.git
```

After syncing and updating the `themes/bilberry-hugo-theme` submodule, changes are committed and pushed to remote.
Now it is ready to be merged into the master branch.
To complete the procedure, after the merge, I do another check of the test content published to the main URL: https://www.bilberry-sandbox.kiroule.com/. 


### Use in Theme Development
Now I want to dwell on how the Bilberry Sandbox is used in my day-to-day development when implementing new features or fixing bugs in the Bilberry theme. 
So, first of all, a few words about my local dev environment.

For any development activities, I use [IntelliJ IDEA](https://www.jetbrains.com/idea/), which is my favorite IDE. 
Usually, I create a separate project for a group of related applications. 
For example, for all Hugo-related development, I have a project that contains my website **kiroule.com**, **Bilberry theme**, and **Bilberry Sandbox**:

![IntelliJ hugo-dev Project](/img/content/article/simplify-development-and-testing-with-bilberry-sandbox/intellij-hugo-dev-project.png)

Since I'm the official maintainer of the Bilberry theme, I no longer need to use the repository I previously forked from the original one. 
For any minor fixes, such as typos in the README page, I can make changes directly to the original's master branch, but for anything else, I would work on a branch created from master.

As for the Bilberry Sandbox, its primary purpose is to test all Bilberry theme's new development in my local dev before committing and pushing to remote. 
Usually, I start any new development by creating a new feature/bugfix branch from the [bilberry-hugo-theme](https://github.com/Lednerb/bilberry-hugo-theme) repository's master.

Then, for the Bilberry sandbox to use the Bilberry theme from the local `bilberry-hugo-theme` repository, the `theme` property in the sandbox's `config.toml` file must be set to a relative path from the `themes` directory to that repository, which in my case will be `../../lednerb/bilberry-hugo-theme` given the following path structure for the theme and sandbox local repositories:
```shell
├── lednerb
│   └── bilberry-hugo-theme
├── bilberry-hugo-theme-sandbox
│   ├── config.toml
```

I build and deploy the sandbox website using the `hugo server` command when a feature or fix is ready for testing. 
Once deployed, any changes made to the theme's source code, except for SCSS files, will automatically force the site to be rebuilt and republished. 
For SCSS files, the `assets/sass/theme.scss` file needs to be updated using either `npm run dev` or `npm run production` commands.

As soon as the development is completed, I push the theme's local branch to remote and revert changes to the sandbox's `config.toml` file. 
Then it's time to follow the above-described [Test Against Fork/Branch](/article/simplify-development-and-testing-with-bilberry-sandbox#test-against-forkbranch) routine, but this time it will be tested against my own branch in the original repository.  
