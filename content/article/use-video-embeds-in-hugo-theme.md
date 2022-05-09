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

{{< toc >}}

With the proliferation of various video-sharing platforms such as [YouTube](https://www.youtube.com/), [Vimeo](https://vimeo.com/), [Bilibili](https://www.bilibili.com/), etc., the ability to post videos or include them in articles has become a necessity for any blog or website.
This can be easily achieved if you plan to use videos from YouTube and Vimeo only, as Hugo includes built-in [youtube](https://gohugo.io/content-management/shortcodes/#youtube) and [vimeo](https://gohugo.io/content-management/shortcodes/#vimeo) shortcodes by default.

### Built-in Shortcodes
For example, to embed a responsive video player to play a YouTube video with the URL https://www.youtube.com/watch?v=qtIqKaDlqXo, you need to place `{{</* youtube qtIqKaDlqXo */>}}` within the article's markdown, where the `qtIqKaDlqXo` value is the video's ID. 
To test the `youtube` shortcode, I created a [test article](https://www.bilberry-sandbox.kiroule.com/article/test-hugo-youtube-shortcode/) on the Bilberry Sandbox website where you can see what the embedded video looks like.

### Raw HTML iframe
So far, so good, but what would you do if you needed to embed videos from video-sharing providers other than YouTube and Vimeo. 
For example, let's say you want to use a video hosted on Bilibili, one of the major Chinese video-on-demand platforms.
Simply trying to place the following `iframe` embed element will not work:
```html
<iframe src="//player.bilibili.com/player.html?bvid=BV1sN411o7fr&page=1&high_quality=1&danmaku=0"
        scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>
```

Since **v0.60.0**, Hugo switched to the Goldmark markdown renderer, which by default omits all raw HTML content embedded in the markdown. 
To make it work, you should add the following setting to your `config.toml` configuration file:
```yaml
[markup]
  [markup.goldmark]
    [markup.goldmark.renderer]
      unsafe = true
```

The `unsafe = true` option may sound intimidating, but it doesn't necessarily make your website insecure. 
Perhaps the creators of Hugo meant that the practice of using raw HTML in markdown should be considered unsafe.
The Bilberry Sandbox, which helps me develop, test, and maintain the Bilberry theme, has the raw HTML rendering enabled.
To try out the Bilibili `iframe` embed, I've created another test [post](https://www.bilberry-sandbox.kiroule.com/article/test-raw-html-iframe-embed/), where I also added the `iframe` from the above YouTube video for comparison.

As you can see from the screenshot, both video embeds are not displayed responsively, i.e., they do not fully fit into the width of the article. 
On the contrary, the YouTube video, which is embedded via the `youtube` shortcode, does fit the article's width.

![Test Raw HTML iframe Embed](/img/content/article/use-video-embeds-in-hugo-theme/bilberry-sandbox-raw-html-iframe-test.png)

![Test Raw HTML iframe Embed](/img/content/article/use-video-embeds-in-hugo-theme/bilberry-sandbox-hugo-youtube-shortcode-test.png)

### Custom Shortcodes
TODO: elaborate

Plan:
Note: all examples will be with YouTube embeds.
- Use embed iframe in markdown as is, but raw HTML will be ignored. Therefore, raw HTML should be enabled. Create an example content on Bilberry Sandbox.
- Create shortcode with the embed iframe - pass the video ID as a parameter. Create example shortcode and content on Bilberry Sandbox.
- Create a video content type - example in the Bilberry Hugo theme, maybe use another existing theme as an example using Bilberry's approach.
- Valid HTML - the frameborder element etc. -> fix it using CSS.
- All these can be applied to other video hosting providers and also to audio hosting providers.

Continue reading the series ["Hugo Theme Recipes"](/series/hugo-theme-recipes/):
{{< series "Hugo Theme Recipes" >}}
