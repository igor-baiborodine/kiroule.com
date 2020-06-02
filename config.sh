#!/usr/bin/env bash

sed -i "s/ALGOLIA_INDEX_NAME_PLACEHOLDER/${ALGOLIA_INDEX_NAME}/g" config.toml
grep 'algolia_indexName' config.toml
