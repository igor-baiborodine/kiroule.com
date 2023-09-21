---
title: "Add Image Lightbox to Hugo Theme"
date: 2023-09-14T16:40:06-04:00

categories: ["Jamstack", "Recipe"]
tags: ["Hugo Theme", "Lightbox", "Modal Zoom"]
series: ["Hugo Theme Recipes"]
toc: false
author: "Igor Baiborodine"
---

If you need to add an image lightbox to your Hugo theme and have no idea how to approach it, read this article, where I
present a simple and effective technique for achieving this. It is a continuation of the
series ["Hugo Theme Recipes"](/series/hugo-theme-recipes/).

<!--more-->

{{< toc >}}

### Getting Started
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

### Pick & Test Plugin

First, picking a suitable plugin from the plethora of available ones might be challenging and time-consuming. Based on
my experience, you can use the following selection criteria:
* It should be a relatively recent development with a public repository on GitHub, Bitbucket, etc.
* Its license should **not** be more restrictive than your Hugo theme license.
* It may also contain other functionalities, such as an image gallery, that you want to add to your Hugo theme.

Second, after narrowing down your choices, you must test selected plugins to see if they work well within your Hugo
theme. It is possible that a plugin's CSS may conflict with your theme's CSS, and that may cause problems with your
chosen plugin functioning correctly.

The technicalities of such testing will depend on the selected plugin and Hugo theme. Most lightbox plugin distributions
come in the form of CSS and JavaScript assets that you should manually add to your theme's `static` folder. For example,
the `static` folder in the Bilberry Hugo theme will look like below after downloading and copying minified assets for
the [DimBox](https://github.com/hphaavikko/dimbox) plugin:

![Theme's Static Folder with Assets](theme-static-folder-with-assets.png)

In your Hugo theme, you locate a partial template file containing the `<head>` and `<body>` tags. For instance, in the
Bilberry Hugo theme, such a partial template is
the [`layouts/_default/baseof.html`](https://github.com/Lednerb/bilberry-hugo-theme/blob/e35ecca9f03c9579a9fca7aba0b5aa01563f197c/v4/layouts/_default/baseof.html)
file. Next, include the plugin's CSS and JavaScript assets in the `<head>` and `<body>` tags, respectively:

```html
<head>
    ...
    <link rel="stylesheet" href="dimbox.min.css" />
    ...
</head>
...
<body>
    ...
    <script src="dimbox.min.js"></script>
    ...
</body>
```

After all this, it's time to create a test article that contains a high-resolution image. Place the raw HTML needed to
add an image within the article's markdown according to the plugin documentation. For most plugins, it is a variation of
the `<a>` tag with custom attributes, e.g., for the Dimbox plugin, that would be the following, given you copied
the `my-test-image.jpg` image to the `static` folder of your website:

```html
<a href="path/to/my-test-image.jpg" data-dimbox="my-test-image">
    <img src="path/to/my-test-image.jpg" alt="This is an awesome image" />
</a>
```

But since raw HTML is used to display the test image, Goldmark's `unsafe` property in the `config.toml` file of your
website should be set to `true`:

```toml
[markup.goldmark]
  [markup.goldmark.renderer]
    unsafe = true
```

Having confirmed with tests that the selected plugin works as expected, it's time to start integrating it into the
theme.

### Integration with Theme

Integrating a plugin with a theme consists of two parts: the plugin's assets integration and custom image render hook
implementation. The first part depends on how asset management and processing are implemented in your Hugo theme.
Suppose the theme does not use any tools for dependency management (e.g., npm) along with an asset processing pipeline (
e.g., Hugo pipes). In that case, it will suffice to save the plugin's resource files in the `static` folder of the theme
and include them in the theme's partial template within the `<head>` and `<body>` tags, as we did earlier while testing
plugins.

If your theme does use dependency management and/or asset processing tools, the plugin's assets will likely need to be
stored in the theme's `assets` folder, and certain changes will need to be made to the dependency management and asset
processing pipelines.

The recipe that I presented above is also applicable when your theme already has support for the image modal zoom, but
for some reason, you want to replace it with a different implementation (plugin). That happened to me while working the
`v4` of the Bilberry Hugo theme, which already had the lightbox support via the Magnific Popup plugin. After migrating
CSS and JavaScript asset processing from `npm` and Laravel Mix to Hugo Pipes, this plugin stopped working, and I could
not pinpoint the root cause of that. Therefore, I had no choice but to replace the Magnific Popup plugin with a new one,
namely DimBox.

As for the second part, the default render hook for images provided by Hugo needs to be replaced by a custom one that
will take into account the implementation details of the selected lightbox plugin. That's because the default hook will
render the markdown for adding an image as an img tag wrapped in the p tag, for example:

```markdown
![My Test Image](path/to/my-test-image.jpg)
```

```html
<p>
    <img src="path/to/my-test-image.jpg" alt="My Test Image">
</p>
```

Conclusion

Continue reading the series ["Hugo Theme Recipes"](/series/hugo-theme-recipes/):
{{< series "Hugo Theme Recipes" >}}
