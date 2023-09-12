---
title: "Bilberry Hugo Theme v4 Released!"
date: 2023-09-05T07:43:00-04:00

categories: ["Bilberry", "Jamstack", "Write-Up"]
tags: ["v4", "Hugo Pipes"]
toc: false
author: "Igor Baiborodine"
---

The long-awaited `v4` of the Bilberry Hugo theme that has been in the works for the last six months is finally released.
The new release is a major version containing a few breaking changes and other essential improvements. In this post, I
shed more light on `v4` features and how they were implemented.

<!--more-->

So, why `v4`? What was the raison d'être of developing a new major version? With the `v3` and previous versions, the
main complaint from the users was that the theme customization, namely applying custom colors and fonts, was rather
inconvenient and cumbersome. The theme's CSS and JavaScript assets management was initially implemented
using [npm](https://www.npmjs.com/) and [Laravel Mix](https://laravel-mix.com/), a Webpack wrapper. 

To generate the theme's custom CSS and JavaScript artifacts, you had to execute an `npm` command in your local
development environment and then commit the generated assets to override the ones provided by the theme. Worse, besides
the above, you had to manage your own theme's fork when importing theme files as a Hugo module.

The solution to this customization hindrance was switching to Hugo's built-in asset
processing, [Hugo Pipes](https://gohugo.io/hugo-pipes/), and that became the main reason for developing the `v4`. With
Hugo Pipes, the asset processing is defined 
in [`v4/layouts/partials/css.html`](https://github.com/Lednerb/bilberry-hugo-theme/blob/v4.0.5/v4/layouts/partials/css.html)
and [`v4/layouts/partials/js.html`](https://github.com/Lednerb/bilberry-hugo-theme/blob/v4.0.5/v4/layouts/partials/js.html)
templates, which use artifacts from v4/assets/sass and v4/assets/js directories, respectively. The third-party
dependencies in the above directories are still managed using `npm` and listed in
the [`devDependencies`](https://github.com/Lednerb/bilberry-hugo-theme/blob/aa76d1808e645d0aad4ecbf7e51d130c28356c36/v4/package.json#L6)
block of the `package.json` file. 

Previously, color and font customizations were handled directly in the `assets/sass/_variables.scss` file. In `v4`,
the `_variables.scss` file no longer exists and such customizations are managed in your site's `config.toml` file by
defining corresponding parameters from the `assets/sass/theme.scss` file, for example, `baseColor`, `headlineFont` etc.

Also, in `v4`, along with the migration to Hugo Pipes, the following new features and improvements were implemented:

* Menu items management in the top navigation is no longer done using a custom approach; it was aligned with Hugo's
  [menu](https://gohugo.io/content-management/menus/) standards.
* The `highlight.js` third-party library was replaced with Hugo's built-in
  code [syntax highlighting](https://gohugo.io/content-management/syntax-highlighting/).
* The Font Awesome icons set was upgraded from `v5` to [`v6`](https://fontawesome.com/v6/icons).
* The Magnific Popup plugin that provided a lightbox for displaying larger images was replaced with
  the [DimBox](https://dimboxjs.com/) plugin.
* A scroll back to the top button. 

Respectively, the [README guide](https://github.com/Lednerb/bilberry-hugo-theme/blob/master/v4/README.md) was updated
because of all these changes, and some sections were thoroughly rewritten. Also,
a [migration guide](https://github.com/Lednerb/bilberry-hugo-theme/blob/master/v4/v4-migration-guide.md) was added to
facilitate a smooth transition of existing websites from `v3` to `v4`.

I hope that with this new major release, current and future users of the Bilberry Hugo theme will enjoy using it and
stay happy and satisfied.
