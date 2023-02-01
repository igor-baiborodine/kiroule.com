#!/usr/bin/env bash

version=$(grep -o 'v[0-9]\.[0-9][0-9]\.[0-9]' go.mod)
sed -i "s/creditsText = .*$/creditsText = \"Bilberry Hugo Theme $version\"/" config/_default/config.toml
sed -i "s/creditsUrl = .*$/creditsUrl = \"https:\/\/github.com\/Lednerb\/bilberry-hugo-theme\/tree\/$version\"/" config/_default/config.toml
