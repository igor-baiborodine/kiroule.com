---
title: "Automate Data Upload to Algolia Index: Revisited"
date: 2021-03-10T07:46:59-05:00
categories: [Blog, Write-Up]
tags: [Algolia, Data Upload, npm]
series: "Building Your Blog, the Geeky Way"
toc: false
author: "Igor Baiborodine"
---

I recently made some changes to the automated upload of data to Algolia; namely, the script that reads and sends data to the appropriate index has been reimplemented using Algolia's JavaScript API client. In this post, which is an addition to the [original post](/article/automate-data-upload-to-algolia-index/) on this topic, I go into detail about JavaScript implementation and upload automation with npm.

<!--more-->

It's been almost nine months since I automated data upload to Algolia using the Python client. This solution worked well, and I haven't had any issues so far. So it would be logical to ask why to reimplement something that already works.

The main reason was to use the same build tools that are used to develop Hugo-based themes. Back then, when Hugo didn't have a built-in asset pipeline, it was natural to use npm for asset bundling, minification, fingerprinting, etc. After actively contributing to the Bilberry Hugo theme, which also uses npm, and gaining some valuable experience, I thought it would be practical to align the data upload with the main stack tools.

Since Netlify's [Ubuntu image](https://github.com/netlify/build-image/blob/v3.7.0/Dockerfile) also comes with node.js and npm preinstalled, the script that reads and pushes index data could easily be rewritten using Algolia API's [JavaScript client](https://github.com/algolia/algoliasearch-client-javascript). The wrapper shell script can be bridged with the new JavaScript implementation using npm. All the above does not affect the configuration of the indices in Algolia and website configuration files located in the `config` directory.

{{< toc >}}

### package.json

```json
{
  "name": "algolia-helper",
  "version": "1.0.0",
  "description": "Algolia helper for sending and managing data",
  "dependencies": {
    "algoliasearch": "^4.8.5",
    "jsonfile": "^6.1.0",
    "yargs": "^16.2.0"
  },
  "scripts": {
    "data-upload": "node data-upload.js"
  },
  "author": "Igor Baiborodine",
  "license": "ISC"
}
```

### data-upload.js

```javascript
const argv = require("yargs/yargs")(process.argv.slice(2))
  .boolean("c").alias("c", "clear-index").describe("c", "Clear Algolia index before upload")
  .alias("f", "index-file").nargs("f", 1).describe("f", "Index file to upload to Algolia")
  .alias("a", "app-id").nargs("a", 1).describe("a", "Algolia application ID")
  .alias("k", "admin-api-key").nargs("k", 1).describe("k", "Algolia admin API key")
  .alias("n", "index-name").nargs("n", 1).describe("n", "Algolia index name")
  .alias("u", "base-url").nargs("u", 1).describe("u", "Site base URL")
  .demandOption(["f", "a", "k", "n"])
  .help("h")
  .alias("h", "help")
  .argv;

const algoliaSearch = require("algoliasearch");
const client = algoliaSearch(argv["app-id"], argv["admin-api-key"]);
const algoliaIndex = client.initIndex(argv["index-name"]);
const jsonfile = require("jsonfile");

const replaceBaseUrl = (indices) => {
  indices.forEach(index => {
    let offset = -2;
    if (index["type"] === "article") {
      offset = -3;
    }
    let tokens = index["url"].split("/").slice(offset);
    index["url"] = argv["base-url"] + "/" + tokens.join("/");
  });
}

const saveObjects = () => {
  jsonfile.readFile(argv["index-file"], function (err, indices) {
    if (err) {
      console.error(err);
    } else {
      if (argv["base-url"]) {
        replaceBaseUrl(indices);
      }
      algoliaIndex.saveObjects(indices).then(() => {
        console.log("Uploaded data to index %s", argv["index-name"]);
      })
      .catch(err => {
        console.log(err);
      });
    }
  })
};

if (argv["clear-index"]) {
  algoliaIndex.clearObjects().then(() => {
    console.log("Cleared data from index %s", argv["index-name"]);
    saveObjects();
  });
} else {
  saveObjects();
}
```

### run-data-upload.sh
### Configuration Files
### netlify.toml
### Netlify Configuration

Continue reading the series ["Building Your Blog, the Geeky Way"](/series/building-your-blog-the-geeky-way/):
{{< series "Building Your Blog, the Geeky Way" >}}
