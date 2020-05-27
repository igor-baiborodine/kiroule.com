#!/usr/bin/env bash
echo "Igor here: "
$pwd
sed -i "s/ALGOLIA_APP_ID_PLACEHOLDER/${HUGO_PARAM_ALGOLIA_APP_ID}/g" ./config.toml
sed -i "s/ALGOLIA_API_KEY_PLACEHOLDER/${HUGO_PARAM_ALGOLIA_API_KEY}/g" ./config.toml
