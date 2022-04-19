---
title: "Add Table of Contents to Hugo Theme"
date: 2020-10-19T08:08:54-04:00

categories: [Jamstack, Recipe]
tags: [Hugo Theme, Table of Contents, TOC]
series: "Hugo Theme Recipes"
toc: false
author: "Igor Baiborodine"
---

This post introduces another enhancement to a Hugo theme - the Table of Contents (TOC). It's based on Hugo's built-in ability to parse Markdown content and generate a table of contents that can be used in templates. This article is the second one in the series "Hugo Theme Recipes".

<!--more-->

Usually, my tutorials or write-ups start with an introductory part. Then follows either detailed steps or implementation details, where each section is headed with an H3(`###`) heading. To make navigation easier within my articles, right after the introductory part, I add a list of anchor links to the sections below; for instance, a link `[Install Hugo](#install-hugo)` will correspond to a section headed with `### Install Hugo`. Such a list is nothing but a table of contents.

Therefore, instead of manually adding a list of anchor links, I wanted to automate the table of contents creation. This can be achieved by using Hugo's built-in feature to automatically parse Markdown content and create a TOC. Based on this feature, I implemented a solution that allows displaying a table of contents using either a shortcode or a page template. 

So let's examine the details of this solution. The source code for the implementation I describe below can be found in my [contribution](https://github.com/Lednerb/bilberry-hugo-theme/commit/dad026fc2517891bf0d931a3b9f1ad339d5d49e0
) to the Bilberry theme.

{{< toc >}}

## Configuration
To define what heading levels need to be included in TOC, you have to add the following to your site config file, for instance, `config.toml`:
```toml
[markup]
  [markup.tableOfContents]
    startLevel = 2
    endLevel = 5
    ordered = false
```
The `startLevel` setting defines the heading level when Hugo starts rendering the table of contents. The `endLevel` sets the heading level(inclusive) when Hugo stops generating the TOC. In the configuration above, all headings starting from H2(`##`) to H5(`#####`) inclusive will be used to create a table of contents. The `ordered` setting determines what type of list to generate, either an ordered list using the `<ol>` tag or an unordered list using the `<ul>` tag.

## Shortcode
As per Hugo [documentation](https://gohugo.io/content-management/toc/), if you have appropriate headings in your markdown, Hugo will extract them and store in the page variable named `.TableOfContents`. 
Since it can only be used in Go templates, you cannot merely place `.TableOfContents` within your content file and expect a TOC to be displayed. What you can do is to wrap it in a shortcode. Within the site root, create the `layouts/shortcodes/toc.html` file that contains the following:
```
{{ .Page.TableOfContents }}
``` 

## Single Page Template/Partial
Then you could go even further and completely automate the creation of the table of contents. То do so, firstly, you need to add the `toc` front matter variable to a default archetype template that is used to create an empty content file in your Hugo theme. In the Bilberry theme, it's the [archetype/default.md](https://github.com/Lednerb/bilberry-hugo-theme/blob/2.4.0/archetypes/default.md). The default value of the `toc` variable should be set to `false`:
```
toc: false
``` 

Secondly, if you want to make the TOC rendering conditional based on the number of words in the content, add the `tocMinWordCount` param to the site config file and set its value you see fit, for instance, `500`:
```toml
[param]
  # Minimum word count to display the Table of Contents
  tocMinWordCount = 500
```

Thirdly, in your [single page template](https://gohugo.io/templates/single-page-templates/), add the following code snippet right before displaying the content:
```html
{{ if and (.Params.toc) (gt .WordCount .Site.Params.tocMinWordCount ) }}
  <h2>{{ i18n "tableOfContents" }}</h2>
  {{ .TableOfContents }}
{{ end }}
```

For example, a simple page template `layout/_default/single.html` may look like this:
```html
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

## i18n
Since the `i18n` function is used to display the `Table of Contents` label, define a value for the `tableOfContents` key in the appropriate i18n configuration file, for instance, [i18n/en.toml](https://github.com/Lednerb/bilberry-hugo-theme/blob/2.4.0/i18n/en.toml):
```toml
[tableOfContents]
  other = "Table of Contents"
```

## Styling
Finally, the last thing to do is to style with CSS the HTML output generated by the `.TableOfContent` variable. The HTML output consists of  a `<nav id="TableOfContents">` element with a child `<ul>`(or `<ol>` depending on the `ordered` setting) that has a child `<li>` element, which in turn contains a child `<ul>`/`<ol>` with a list of `<li>` elements. Each `<li>` contains an `<a>` element that points to the corresponding content heading. Here's an example of such HTML:
```html
<nav id="TableOfContents">
  <ul>
    <li>
      <ul>
        <li><a href="#header-h2-1">Header H2 1</a></li>
        <li><a href="#header-h2-2">Header H2 2</a></li>
        <li><a href="#header-h2-3">Header H2 3</a></li>
      </ul>
    </li>
  </ul>
</nav>
```

How you style your table of contents will depend a lot on the theme you are using. In my case with the Bilberry theme, the styling was implemented using the SCSS syntax as follows:
```scss
#TableOfContents {
  display: block;
  background: transparent;
  padding-bottom: 2rem;
  font-size: 1.2em;

  ul {
    display: list-item;
    padding-left: 0;
    
    &:not(:first-child) {
      display: list-item;
      padding-left: 0.9rem;
      font-size: 95%;
    }
  }

  li {
    display: inherit;
    color: $text-color;

    a {
      color: inherit;
      text-align: left;
      padding: 0;

      &:hover {
        color: $highlight-color;
        background-color: transparent;
      }
    }
  }
}
```

A TOC with the above styling will look like [this](https://bilberry-toc-test.netlify.app/article/toc-test-h2-h3-h4-h5/):

![TOC Sample with Styling](/img/content/article/add-table-of-contents-to-hugo-theme/toc-sample-with-styling.png)

## Usage
If you want to display the table of contents at a specific point in the markdown content, use the `toc.html` shortcode:
```
{{</* toc */>}}
```
In case you want to show the TOC right at the beginning of the content, set the `toc` page variable to `true`:
```
toc: true
``` 

## Conclusion
To sum up, the presented solution offers two options for automating the creation of a table of contents. You can use either one or both. The shortcode approach is more straightforward and less dependent on the implementation of the Hugo theme of your choice. Also, you can place the shortcode anywhere within the markdown content. On the other hand, the single page template/partial approach is more theme-dependent, and the generated TOC has a fixed position within displayed content. Still, it's easier to use by simply enabling the corresponding page variable.


