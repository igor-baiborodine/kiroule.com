#!/usr/bin/env bash

cat go.mod
version=$(grep -Po '(?<=v4\s)[^\s//]+' go.mod)
sed -i "s/creditsText = .*$/creditsText = \"Bilberry Hugo Theme $version\"/" config/_default/hugo.toml
sed -i "s/creditsUrl = .*$/creditsUrl = \"https:\/\/github.com\/Lednerb\/bilberry-hugo-theme\/tree\/$version\"/" config/_default/hugo.toml
printf "updated version with %s\n" "$version"
