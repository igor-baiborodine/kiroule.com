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

Below you can learn more about the new implementation. The source code is available [here](https://github.com/igor-baiborodine/kiroule.com/tree/automate-index-upload-revisited).

{{< toc >}}

### data-upload.js

To clear the corresponding Algolia index before starting a new upload, I added the `-c` or `--clear-index` option.  Also, I ran into a bug in the code that replaces the base URL in the `url` index field value when the `--base-url` option is specified.

In the course of the initial implementation, I missed the fact that the `url` index field value for articles is created differently from the `url` value for tags, categories, and authors during the generation of the `index.json` file, specifically, the `url` for articles ends with a `/`. To deal with this discrepancy, I had to introduce a variable to offset the slicing of tokens obtained as a result of splitting on `/` the original `url` value.

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

This script can be tested in the local dev by executing the following commands in the site's root:

```shell
# install dependencies: algoliasearch, jsonfile, yargs
$ npm install "algolia"

# generate public/index.json with index data
$ hugo

# clear Algolia index and push data
$ npm --prefix "algolia" run data-upload -- \ 
    -c \
    -f public/index.json \
    -a <algolia-app-id> \
    -k <algolia-admin-api-key> \
    -n <algolia-index-name> \
    # specify this option 
    # if you use a separate Algolia index for the local dev
    -u http://localhost:1313 
```

### package.json

To install dependencies and execute the `data-upload.js` script from within the `run-data-upload.sh` wrapper script, I added a `package.json` file containing definitions for a script command and required packages for the `data-upload.js`.

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

### run-data-upload.sh

To adapt this wrapper script to use npm, I made the following adjustments: 
1. `pip install --upgrade 'algoliasearch>=2.0,<3.0'` was replaced with `npm install "algolia"` 
2. `python algolia/data-upload.py` was replaced with `npm --prefix "algolia" run data-upload --  -c` 

```shell
#!/usr/bin/env bash

while getopts "pf:a:k:n:u:" opt; do
  case $opt in
  # netlify
  p) npm install "algolia"
    # Environment variables below (except PWD) should be configured
    # in the section 'Build & deploy/Environment variables' of your site in Netlify;
    # Alternatively, the ALGOLIA_INDEX_NAME variable can be defined in the netlify.toml file.
    index_file="$PWD/$HUGO_INDEX_FILE"
    app_id="$ALGOLIA_APP_ID"
    admin_api_key="$ALGOLIA_ADMIN_API_KEY"
    index_name="$ALGOLIA_INDEX_NAME"
    ;;
  # local dev
  f) index_file="$OPTARG" ;;
  a) app_id="$OPTARG" ;;
  k) admin_api_key="$OPTARG" ;;
  n) index_name="$OPTARG" ;;
  u) base_url="$OPTARG" ;;
  \?) echo "Invalid option: -$OPTARG" >&2 ;;
  esac
done

npm --prefix "algolia" run data-upload -- -c \
    -f "$index_file" \
    -a "$app_id" \
    -k "$admin_api_key" \
    -n "$index_name" \
    -u "$base_url"
```

### Configuration Files

The site configuration files have not changed.

### netlify.toml

In the build command,  the Python-based wrapper script was replaced with the npm-based one. Also, I removed the `-u $DEPLOY_PRIME_URL` option for `run-data-upload-js.sh` script from the build command in the dev deployment context. Obviously, when the `-b $DEPLOY_PRIME_URL` flag is specified for the `hugo` command, the values of the `url` index field in the `public/index.json` file will contain the base URL corresponding to the dev deployment context and not to the production one.

```toml
[build]
  publish = "public"
  command = "hugo"

# URL: https://kiroule.com/
[context.production.environment]
  HUGO_VERSION = "0.72.0"
  HUGO_ENV = "production"
  HUGO_ENABLEGITINFO = "true"
  # Algolia index name is needed to execute algolia/run-data-upload-js.sh
  ALGOLIA_INDEX_NAME = "prod_kiroule"

[context.production]
  command = "hugo && algolia/run-data-upload-js.sh -p"

# URL: https://dev--kiroule.netlify.app/
[context.dev.environment]
  HUGO_VERSION = "0.72.0"
  # Algolia index name is needed to execute algolia/run-data-upload-js.sh
  ALGOLIA_INDEX_NAME = "dev_kiroule"

[context.dev]
  command = "hugo --environment dev -b $DEPLOY_PRIME_URL && algolia/run-data-upload-js.sh -p"
```

### Netlify Configuration

The Netlify site configuration has not changed.

And to conclude this post, I want to note that this was my first real experience of task automation using npm. I hope that the new JavaScript/npm solution will perform well and be as good as the Python-based implementation.

Continue reading the series ["Building Your Blog, the Geeky Way"](/series/building-your-blog-the-geeky-way/):
{{< series "Building Your Blog, the Geeky Way" >}}
