---
title: "Add Image Lightbox to Hugo Theme"
date: 2023-09-14T16:40:06-04:00

categories: ["Jamstack", "Recipe"]
tags: ["Hugo Theme", "Lightbox", "Modal Zoom"]
series: ["Hugo Theme Recipes"]
toc: true
author: "Igor Baiborodine"
---

If you need to add an image lightbox to your Hugo theme and have no idea how to approach it, read this article, where I
present a simple and effective technique for achieving this. It is a continuation of the
series ["Hugo Theme Recipes"](/series/hugo-theme-recipes/).

<!--more-->

What is an image lightbox? An image lightbox, also sometimes called an image modal zoom, is a window overlay that goes
over the website's currently displayed webpage to show a larger version of the image when the reader clicks on it.
This "magnification" lets the reader view high-resolution images in great detail. Such a feature would be a great
addition to a Hugo theme and, consequently, to a website based on such a Hugo theme.

So, where to start? It all comes down to two options. If you're well versed in CSS and JavaScript, you can roll up your
sleeves and implement an image lightbox yourself. The second option would be integrating an existing third-party image
lightbox plugin into your Hugo theme. In my case, while working on
the [Bilberry Hugo theme](https://github.com/Lednerb/bilberry-hugo-theme), I opted for a third-party
plugin since I'm not that good at CSS and JavaScript and didn't have enough spare time to implement it myself, so the
recipe shown below is based on a third-party plugin.

First, picking a suitable plugin from the plethora of available ones might be challenging and time-consuming. Based on
my experience, you can use the following selection criteria:
* It should be a relatively recent development with a public repository on GitHub, Bitbucket, etc.
* Its license should not be more restrictive than your Hugo theme license.
* It may also contain other functionalities, such as an image gallery, that you want to add to your Hugo theme.

After narrowing down your choices, you must test selected plugins to see if they work well within your Hugo theme. It
is possible that a plugin's CSS may conflict with your theme's CSS, which may cause problems with your chosen plugin
functioning correctly.

The recipe that I presented above is also applicable when your theme already has support for the image modal zoom, but
for some reason, you want to replace it with a different implementation (plugin). That happened to me while working the
`v4` of the Bilberry Hugo theme, which already had the lightbox support via the Magnific Popup plugin. After migrating CSS
and JavaScript asset processing from `npm` and Laravel Mix to Hugo Pipes, this plugin stopped working, and I could not
pinpoint the root cause of that. Therefore, I had no choice but to replace the Magnific Popup plugin with a new one, namely
DimBox.

Conclusion

Continue reading the series ["Hugo Theme Recipes"](/series/hugo-theme-recipes/):
{{< series "Hugo Theme Recipes" >}}
