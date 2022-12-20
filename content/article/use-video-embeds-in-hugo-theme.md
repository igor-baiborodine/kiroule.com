---
title: "Use Video Embeds in Hugo Theme"
date: 2022-05-12T18:05:12-05:00
draft: false
categories: ["Jamstack", "Recipe"]
tags: ["Hugo Theme", "Video Embed"]
series: ["Hugo Theme Recipes"]
toc: true
author: "Igor Baiborodine"
---

In this article, I will show how to handle video embedding when creating content for a Hugo-based
website or enhancing a Hugo theme; it continues the
series ["Hugo Theme Recipes"](/series/hugo-theme-recipes/).

<!--more-->

With the proliferation of various video-sharing platforms such
as [YouTube](https://www.youtube.com/), [Vimeo](https://vimeo.com/)
, [Bilibili](https://www.bilibili.com/), etc., the ability to post videos or include them in
articles has become a necessity for any blog or website. This can be easily achieved if you plan to
use videos from YouTube and Vimeo only, as Hugo includes
built-in [youtube](https://gohugo.io/content-management/shortcodes/#youtube)
and [vimeo](https://gohugo.io/content-management/shortcodes/#vimeo) shortcodes by default.

### Built-in Shortcodes

For example, to embed a responsive video player to display a YouTube video with the
URL https://www.youtube.com/watch?v=qtIqKaDlqXo, you simply need to
place `{{</* youtube qtIqKaDlqXo */>}}` within the article's markdown, where the `qtIqKaDlqXo` value
is the video's ID. To test the `youtube` shortcode, I created
a [test article](https://www.bilberry-sandbox.kiroule.com/article/test-hugo-youtube-shortcode/) on
the Bilberry Sandbox website where you can see what the embedded video looks like.

### Raw HTML iframe

So far, so good, but what would you do if you need to embed videos from video-sharing providers
other than YouTube and Vimeo. For example, let's say you want to use a video hosted on Bilibili, one
of the major China's video-on-demand platforms. Simply trying to place the following `iframe` embed
will not work:

```html
<iframe src="//player.bilibili.com/player.html?bvid=BV1jz4y1f7yo&page=1&high_quality=1&danmaku=0"
        scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"></iframe>
```

Since **v0.60.0**, Hugo switched to the Goldmark markdown renderer, which by default omits all raw
HTML content embedded in the markdown. To make it work, you should add the following setting to
your `config.toml` configuration file:

```yaml
[markup]
  [markup.goldmark]
    [markup.goldmark.renderer]
      unsafe = true
```

The `unsafe = true` option may sound intimidating, but it doesn't necessarily make your website
insecure. Perhaps the creators of Hugo meant that the practice of using raw HTML in markdown should
be considered unsafe. The Bilberry Sandbox, which helps me develop, test, and maintain the Bilberry
theme, has the raw HTML rendering enabled. To try out the Bilibili `iframe` embed, I've created
another test [post](https://www.bilberry-sandbox.kiroule.com/article/test-raw-html-iframe-embed/),
where I also added the `iframe` from the above YouTube video for comparison.

As you can see from the first screenshot below, both video embeds are not displayed responsively, i.e.,
they do not fully fit into the width of the article. In contrast, a YouTube video in the second
screenshot, which is embedded via the `youtube` shortcode, does fit the article's width since
its `iframe` element and its surrounding `div` have the required inline CSS styling.

![Raw HTML iframe Embed](/img/content/article/use-video-embeds-in-hugo-theme/bilberry-sandbox-raw-html-iframe-test.png)

![Hugo youtube Shortcode](/img/content/article/use-video-embeds-in-hugo-theme/bilberry-sandbox-hugo-youtube-shortcode-test.png)

### Custom Shortcodes

Additionally, before addressing the issue with responsiveness, we can encapsulate the `iframe` embed
in a custom shortcode instead of using it as a raw HTML, i.e., create a parametrizable shortcode
similar to the `youtube` shortcode provided by Hugo. Here is
the [layouts/shortcodes/bilibili.html](https://github.com/igor-baiborodine/bilberry-hugo-theme-sandbox/blob/f8421ec95b92b3f11f4e30c748247431e71b2fab/layouts/shortcodes/bilibili.html)
shortcode file I added to the Bilberry Sandbox:

```html
{{ $id := .Get 0 }}

<div>
  <iframe
      src="https://player.bilibili.com/player.html?bvid={{ $id }}&page=1&as_wide=1&high_quality=1&danmaku=0"
      scrolling="no" framespacing="0" webkitallowfullscreen mozallowfullscreen allowfullscreen>
  </iframe>
</div>
```

To display the above-mentioned Bilibili video in an article, you need to
put `{{</* bilibili BV1jz4y1f7yo */>}}` within the article's markdown, where the `BV1jz4y1f7yo`
value is the video's ID. As you can see, the video embed in
the [test article](https://www.bilberry-sandbox.kiroule.com/article/test-bilibili-embed-shortcode/)
is displayed the same way as the raw HTML `iframe` embed. But when using the `bilibili` shortcode,
you no longer need to apply the `unsafe = true` setting in the configuration file.

### Responsiveness

To fix the issue with responsiveness when using custom shortcodes, you should define an external CSS
styling for the `div` element containing the `iframe`. For example, in the Bilberry theme, this
styling is implemented using the SCSS syntax
as [follows](https://github.com/Lednerb/bilberry-hugo-theme/blob/93290d430a60052aa8ab421d21a50a63fa64cd04/assets/sass/_articles.scss):

```scss
&.article {
    .responsive-video {
        position: relative;
        /* 16:9 ratio*/
        padding-bottom: 56.25%;
        padding-top: 0px;
        height: 0;
        overflow: hidden;

        iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: 0;
        }
    }
}
```

Then to apply the above styling, you should set the div's class attribute with
the `responsive-video` value: `<div class="responsive-video">`.

### Enhanced YouTube Shortcode
When using Hugo's built-in `youtube` shortcode, it will render as follows:
```html
<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden;">
  <iframe src="https://www.youtube.com/embed/qtIqKaDlqXo"
          style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border:0;"
          allowfullscreen="" title="YouTube Video"></iframe>
</div>
```

As you can see, the `src` attribute of the iframe element is set
to `https://www.youtube.com/embed/qtIqKaDlqXo`. With this source URL, YouTube will automatically use
its tracking cookie. Unfortunately, that can pose a problem since the people visiting your site
usually do not consent to this YouTube tracker. In 2020, YouTube introduced a new privacy-enhanced
video embed that you can use to create your improved no-cookie YouTube shortcode. Here is
the [youtube-enhanced](https://github.com/igor-baiborodine/bilberry-hugo-theme-sandbox/blob/d045f03af3f97024b9e659a623b81ce78ae02c4a/layouts/shortcodes/youtube-enhanced.html)
shortcode, which I implemented in the Bilberry Sandbox:

```html
{{ $id := .Get "id" | default (.Get 0) }}
{{ $start := .Get "start" | default 0 }}
{{ $title := .Get "title" | default "YouTube Video" }}

<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden;">
  <iframe src="https://www.youtube-nocookie.com/embed/{{ $id }}?rel=0&start={{ $start }}"
          style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border:0;"
          allowfullscreen="" title="{{ $title }}"></iframe>
</div>
```

I created the
following [content](https://www.bilberry-sandbox.kiroule.com/article/test-enhanced-youtube-shortcode/)
to test this custom shortcode. It can be used the same way as the original shortcode from Hugo:

```markdown
# Providing only the video ID as an unnamed parameter
{{</* youtube-enhanced qtIqKaDlqXo */>}}

# Providing only the video ID as the named id parameter
{{</* youtube-enhanced id="qtIqKaDlqXo" */>}}

# Providing values for named id, title, and start parameters
{{</* youtube-enhanced id="qtIqKaDlqXo" title="Hugo Introduction" start="120" */>}}
```

If the `title` parameter is omitted, it will default to the `YouTube Video` value. If you want to
start playing a video from a specific point, provide the `start` parameter, whose value should be in
seconds. In addition, the source URL for the video in question contains the `rel` parameter, which
is set to `0`. This parameter determines whether the player should show related videos when the
playback of the initial video ends. If set to `0`, no related videos will be
shown. [Here](https://developers.google.com/youtube/player_parameters) you can read more on other
supported YouTube player parameters. Also, you can externalize the inline CSS styling by moving it
into a separate either CSS, SCSS, or SASS file.

### Conclusion

Because Hugo provides shortcodes for two of the most popular video-sharing providers, YouTube and
Vimeo, posting videos from them doesn't require any extra effort. However, the provided `youtube`
shortcode lacks privacy, which can be easily addressed by implementing your custom YouTube
shortcode. If you want to publish a video from any other provider, then this can be achieved by
either using a raw HTML `iframe` embed or encapsulating it in a custom shortcode. I also want to
point out that the presented solution for creating video embed shortcodes can be applied to audio
embedding.

Continue reading the series ["Hugo Theme Recipes"](/series/hugo-theme-recipes/):
{{< series "Hugo Theme Recipes" >}}
