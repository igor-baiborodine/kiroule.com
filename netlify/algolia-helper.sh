#!/usr/bin/env bash

# test to not expose sensitive stuff in config.toml
#sed -i "s/ALGOLIA_APP_ID_PLACEHOLDER/${HUGO_PARAM_ALGOLIA_APP_ID}/g" config.toml
#sed -i "s/ALGOLIA_API_KEY_PLACEHOLDER/${HUGO_PARAM_ALGOLIA_API_KEY}/g" config.toml

python3 --version
pip install --upgrade 'algoliasearch>=2.0,<3.0'