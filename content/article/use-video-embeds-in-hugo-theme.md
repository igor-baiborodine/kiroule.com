---
title: "Use Video Embeds in Hugo Theme"
date: 2022-04-29T18:05:12-05:00
draft: false
categories: [Jamstack, Recipe]
tags: [Hugo Theme, Video Embed]
series: "Hugo Theme Recipes"
toc: false
author: "Igor Baiborodine"
---

In this article, I will show how to handle video embedding when creating content for a Hugo-based website or enhancing a Hugo theme; 
it continues the  series ["Hugo Theme Recipes"](/series/hugo-theme-recipes/).

<!--more-->

With the proliferation of various video-sharing platforms such as YouTube, Vimeo, Bilibili, etc., the ability to post videos or include them in articles is a necessity for any blog or website.
If we look at how this can be done when using a Hugo-based website, it will largely depend on your chosen Hugo theme.

{{< toc >}}

### Details 1
### Details 2
### Details 3

Plan:
Note: all examples will be with YouTube embeds.
- Use embed iframe in markdown as is, but raw HTML will be ignored. Therefore, raw HTML should be enabled. Create an example content on Bilberry Sandbox.
- Create shortcode with the embed iframe - pass the video ID as a parameter. Create example shortcode and content on Bilberry Sandbox.
- Create a video content type - example in the Bilberry Hugo theme, maybe use another existing theme as an example using Bilberry's approach.
- Valid HTML - the frameborder element etc. -> fix it using CSS.
- All these can be applied to other video hosting providers and also to audio hosting providers.

Continue reading the series ["Hugo Theme Recipes"](/series/hugo-theme-recipes/):
{{< series "Hugo Theme Recipes" >}}
