#!/usr/bin/env bash

sed -i "s/GOOGLE_ANALYTICS_ID_PLACEHOLDER/${GOOGLE_ANALYTICS_ID}/g" config.toml
sed -i "s/ALGOLIA_INDEX_NAME_PLACEHOLDER/${ALGOLIA_INDEX_NAME}/g" config.toml

grep 'googleAnalytics|algolia_indexName' config.toml
