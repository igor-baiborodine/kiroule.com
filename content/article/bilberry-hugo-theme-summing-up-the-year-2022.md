---
title: "Bilberry Hugo Theme: Summing Up the Year 2022"
date: 2023-01-01T18:00:00-05:00

categories: ["Bilberry", "Jamstack", "Write-Up"]
tags: ["Development", "Overview"]
toc: false
author: "Igor Baiborodine"
---

In November 2021, I became the official maintainer of the Bilberry Hugo theme, and this post is a quick overview of how
this theme has evolved in 2022.

<!--more-->

Back then, in November 2021,
I [asked](https://github.com/Lednerb/bilberry-hugo-theme/discussions/293) Sasha Brendel, the theme owner, if there were
any plans for a new release since the last version of the theme was published on October 6, 2020. To which he replied
that he did not have enough time to maintain it at the proper level and offered to join the project and become an
official maintainer. I accepted his offer and already published
the [2.5.0](https://github.com/Lednerb/bilberry-hugo-theme/releases/tag/2.5.0) release on November 5. Other releases
followed, bringing the total number to **27** to date.

Another question that I immediately addressed was how to better organize and provide support to the theme's users.
Instead of using [Discord](https://discord.com/) as a communication channel, I proposed
using [GitHub Discussions](https://github.com/features/discussions) along
with [GitHub Issues](https://github.com/features/issues) for this. The main advantage of this was to keep the project
and related discussions in one place. It would also make it easier to manage incoming requests, which could be
categorized as real issues(defects or bugs) or theme usage questions, ideas(feature requests), and other general
inquiries. And a year after switching to GitHub Discussions, I can testify that it was the right decision, and the
experience of using it is only positive.

The other problem I faced as the official maintainer was how to facilitate and speed up the testing of changes submitted
by other contributors. Testing in my local dev wasn't enough, and I needed a production-like environment with a website
powered by a vanilla Bilberry Hugo theme. Therefore, I created
the [Bilberry Sandbox](https://www.bilberry-sandbox.kiroule.com/), which helps me develop, test, and maintain the
Bilberry theme. Please read the
article ["Simplify Development and Testing with Bilberry Sandbox"](/article/simplify-development-and-testing-with-bilberry-sandbox/)
for more details.

Here is a recap of what has been added, improved, and fixed in 2022, thanks to the collaborative effort of numerous
volunteers.

**New Features**
- Support for the optional `rel` attribute in social media links configuration 
- Enable showing the reading time per article
- Lightbox(modal zoom) support for images within the `<figure>` tag
- Support for using the theme as a Hugo module
- Support for Google Analytics `v4`
- Dutch and European Portuguese translations
- Archive page with enabling the archive link in the footer
- Support for videos hosted on [Bilibili](https://www.bilibili.com/) and [PeerTube](https://joinpeertube.org/) sites
- Support for [giscus](https://giscus.app/) and [utterances](https://utteranc.es/) comments
- Support for audio files in the `Ogg`, `MP3`, or `WAV` formats, either stored externally or within the site's static folder

**Improvements**
- Switch to Hugo's `_internals/opengraph.hmtl` in the `baseof.html` layout file
- Bump Hugo's min version to `v0.93.3`
- Miscellaneous minor styling updates in SCSS files
- Make hyperlinks more obvious in the article's content 
- Updates to French, Danish, and Russian translations
- New GitHub action to automate generation of the table of contents in the `README`
- Complete rework of the `README` along with several new sections
- Various `dependabot` dependency and security updates

**Bug Fixes**
- Make image as a hyperlink working
- Encoding issue caused by series' name containing non-ASCII characters
- `Categories` and `Social Media` in the footer are not centered in responsive mode
- Search form hijacking focus
- Long title/subtitle overlapping header

From all of the above, I would like to point out that it became possible to use the theme as
a [Hugo module](https://gohugo.io/hugo-modules/). Of course, it required effort, and not everything worked out the first
time, but nevertheless, this feature was successfully implemented.

Last but not least, to improve the theme's visibility, I have updated
the [relevant information](https://themes.gohugo.io/themes/bilberry-hugo-theme/) in the themes catalog on Hugo's
website. Also, I added the [Bilberry Hugo theme](https://jamstackthemes.dev/theme/bilberry-hugo-theme/) to the Jamstack
Themes website.

The Bilberry Hugo theme has now:
- 296+ [stars](https://github.com/Lednerb/bilberry-hugo-theme/stargazers)
- 142+ [forks](https://github.com/Lednerb/bilberry-hugo-theme/network/members)
- 45+ [contributors](https://github.com/Lednerb/bilberry-hugo-theme/graphs/contributors)
- 21+ [translations](https://github.com/Lednerb/bilberry-hugo-theme/tree/master/i18n)
