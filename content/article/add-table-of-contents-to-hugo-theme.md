---
title: "Add Table of Contents to Hugo Theme"
date: 2020-10-19T08:08:54-04:00
draft: false
categories: [Theme, Recipe]
tags: [Hugo, TOC]
series: "Hugo Theme Recipes"
toc: false
author: "Igor Baiborodine"
---

This post introduces another enhancement to a Hugo theme - the Table of Contents (TOC). It's based on Hugo's built-in ability to parse Markdown content and generate a table of contents that can be used in templates. This article is the second one in the "Hugo Theme Recipes" series.

<!--more-->

Usually, my tutorials or write-ups start with an introductory part. Then follows either detailed steps or implementation details, where each section is headed with an H3(`###`) heading. To make navigation easier within my articles, right after the introductory part, I add a list of anchor links to the sections below; for instance, a link `[Install Hugo](#install-hugo)` will correspond to a section headed with `### Install Hugo`. Such a list is nothing but a table of contents.

Therefore, instead of manually adding a list of anchor links, I wanted to automate the table of contents creation. This can be achieved by using Hugo's built-in feature to automatically parse Markdown content and create a TOC. As per Hugo [documentation](https://gohugo.io/content-management/toc/), if you have appropriate headings in your markdown, Hugo will extract them and store in the page variable named `.TableOfContents`. 

Since it can only be used in Go templates, you cannot merely place `.TableOfContents` within your content file and expect a TOC to be displayed. What you can do is to wrap it in a shortcode. Within the site root, create the `layouts/shortcodes/toc.html` file that contains the following:
```
{{ .Page.TableOfContents }}
``` 
Next, you can use this shortcode in your content file anywhere you want:
```
{{</* toc */>}}
```
To define what heading levels need to be included in TOC, you have to add the following to your site config file, for example, `config.toml`:
```
[markup]
  [markup.tableOfContents]
    startLevel = 2
    endLevel = 5
    ordered = false
```
The `startLevel` setting defines the heading level when Hugo starts rendering the table of contents. The `endLevel` sets the heading level(inclusive) when Hugo stops generating the TOC. In the configuration above, all headings starting from H2(`##`) to H5(`#####`) inclusive will be used to create a table of contents. The `ordered` setting determines what type of list to generate, either an ordered list using the `<ol>` tag or an unordered list using the `<ul>` tag.

Then you could go even further and completely automate the creation of the table of contents. То do so, firstly, you need to add the `toc` front matter variable to a default archetype template that is used to create an empty content file in your Hugo theme. In the Bilberry theme, it's the [archetype/default.md](https://github.com/Lednerb/bilberry-hugo-theme/blob/2.4.0/archetypes/default.md). The default value of the `toc` variable should be set to `false`:
```
toc: false
``` 

Secondly, if you want to make the TOC rendering conditional based on the number of words in the content, add the `tocMinWordCount` param to the site config file and set its value you see fit:
```
[param]
  # Minimum word count to display the Table of Contents
  tocMinWordCount = 500
```

Thirdly, in your [single page template](https://gohugo.io/templates/single-page-templates/), add the following code snippet right before displaying the content:
```
{{ if and (gt .WordCount .Site.Params.tocMinWordCount ) (.Params.toc) }}
  <h2>{{ i18n "tableOfContents" }}</h2>
  {{ .TableOfContents }}
{{ end }}
```

Or, a simple page template `layout/_default/single.html` may look like this:
```
{{ define "main" }}
<main>
  <article>
    <header>
      <h1>{{ .Title }}</h1>
    </header>

    {{ if and (.Params.toc) (gt .WordCount .Site.Params.tocMinWordCount ) }}
      <h2>{{ i18n "tableOfContents" }}</h2>
      {{ .TableOfContents }}
    {{ end }}

    {{ .Content }}
  </article>
</main>
{{ end }}
```

So, in the above example, the TOC will only be rendered when the following conditions are met:
- the `toc` page variable is set to `true`
- the number of words in the content is greater than the value defined in the `tocMinWordCount` site config setting
- the content has appropriate headings that are within the range defined by the `startLevel` and `endLevel` site config settings


