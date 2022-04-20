---
title: "Integrate Google Analytics with Hugo Theme"
date: 2022-04-18T13:25:12-04:00

categories: [Jamstack, Recipe]
tags: [Hugo Theme, Google Analytics]
series: "Hugo Theme Recipes"
toc: false
author: "Igor Baiborodine"
---

This article provides a quick recipe for integrating Google Analytics with a Hugo theme. 
Hugo comes with a group of built-in internal templates, including those required to use Google Analytics, and I'll show you how to incorporate them into the Hugo theme.

<!--more-->

When checking out Hugo themes, such as those featured on the [Hugo Themes](https://themes.gohugo.io/) website, you will see that most of them are already integrated with Google Analytics.
But in the case where you've built a website using a Hugo theme that doesn't have this integration, or you're implementing your own Hugo theme, adding Google Analytics support is relatively easy and straightforward.

As per the [documentation](https://gohugo.io/templates/internal/#use-the-google-analytics-template), Hugo provides two internal templates for Google Analytics, namely `google_analytics_async.html` and `google_analytics.html`, where the former can be used for **v3** and the latter for **v4**. 
Google Analytics v3 is also known as **Universal Analytics**.
But as I tested, the `google_analytics.html` template can be used for both v3 and v4 versions.
Also, support for v4 in Hugo is available starting with the [v0.82.0](https://github.com/gohugoio/hugo/releases/tag/v0.82.0) release.

So the first step would be to include the `google_analytics.html` within your theme's layout template that contains the `<head>` HTML tag. For example, the template in question in the Bilberry theme is the [layouts/_default/baseof.html](https://github.com/Lednerb/bilberry-hugo-theme/blob/a3c07f898c9de73ac5ebcb87d3b7f2d3ab81d10e/layouts/_default/baseof.html) file. 
In other themes, it is called the [layouts/partials/head.html](https://github.com/adityatelange/hugo-PaperMod/blob/master/layouts/partials/head.html) like in the PaperMod theme.
Placing the line below within these files towards the end will do the job:
```html
{{ template "_internal/google_analytics.html" . }}
```

Then the second step is to add the `googleAnalytics` property to the theme's configuration file, for example, `config.toml`:
```toml
# v3
googleAnalytics = 'UA-PROPERTY_ID'
# v4
googleAnalytics = 'G-MEASUREMENT_ID'
```

Setting this property to your tracking ID will enable Google Analytics. 
So you might be wondering which version of such identifier to use. 
For example, if you created your property after October 14, 2020, you're likely using a Google Analytics v4 property already, and the identifier for such property is prefixed with the letter `G`. 
But if your property was created before October 14, 2020, you're likely using Universal Analytics, i.e., v3, and the tracking ID value should be prefixed with the letters `UA`.

But given that Universal Analytics will no longer process new data in standard properties beginning July 1, 2023, you will have to create a Google Analytics v4 property linked to your existing v3 property. 
In that case, you should still continue using the v3 tracking ID value in the `config.toml` file.

As I said, using the `google_analytics.html` template will work for both v3 and v4 versions. 
So as you can see from the screenshots below, depending on the version of your tracking ID, the corresponding Google Analytics JavaScript library will be loaded: `analytics.js` for v3 and `gtag.js` for v4.

![Google Analytics gtag.js](/img/content/article/integrate-google-analytics-with-hugo-theme/ga-js-library-gtag.png)

![Google Analytics gtag.js](/img/content/article/integrate-google-analytics-with-hugo-theme/ga-js-library-analytics.png)

And in conclusion, I would add that this recipe is generic enough and can be used for any theme based on Hugo. 
As you can see, the presented solution is simple and easy to implement.

Continue reading the series ["Hugo Theme Recipes"](/series/hugo-theme-recipes/):
{{< series "Hugo Theme Recipes" >}}
