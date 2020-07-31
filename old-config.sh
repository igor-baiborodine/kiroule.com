#!/usr/bin/env bash
# DO NOT USE!!!
# Replaced by Hugo's configuration directory. See content of config/ directory.

sed -i "s/GOOGLE_ANALYTICS_ID_PLACEHOLDER/${GOOGLE_ANALYTICS_ID}/g" config.toml
sed -i "s/ALGOLIA_INDEX_NAME_PLACEHOLDER/${ALGOLIA_INDEX_NAME}/g" config.toml

grep -E 'googleAnalytics|algolia_indexName' config.toml
