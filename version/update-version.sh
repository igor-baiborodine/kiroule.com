#!/usr/bin/env bash

version=$(grep -Po '(?<=v4\s)[^\s//]+' go.mod)
sed -i "s/creditsText = .*$/creditsText = \"Bilberry Hugo Theme $version\"/" config/_default/config.toml
sed -i "s/creditsUrl = .*$/creditsUrl = \"https:\/\/github.com\/Lednerb\/bilberry-hugo-theme\/tree\/$version\"/" config/_default/config.toml
