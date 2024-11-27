#!/bin/bash

export COMPONENTS_DIR="components"
export COMPONENTS_PAGES_DIR="components/pages"
export APP_DIR="app"

export COMMON_DEV_DEPENDENCIES=(
    "prettier"
    "concurrently"
    "react-icons"
)

export CHAKRA_DEPENDENCIES=(
    "@chakra-ui/react"
    "@emotion/react"
    "@chakra-ui/cli"
)

export PACKAGE_JSON_SCRIPTS='{
    "sort-imports": "npx eslint --fix \"{app,lib,components,hooks,middleware,e2e,providers}/**/*.{ts,tsx,mdx}\"",
    "prettier": "prettier --write \"{app,lib,components,hooks,middleware,e2e,providers}/**/*.{ts,tsx,mdx}\" --cache --end-of-line lf --use-tabs false --single-quote --arrow-parens avoid --tab-width 2",
    "clean": "concurrently \"pnpm sort-imports\" \"pnpm prettier\""
}'

export ESLINT_CONFIG='{
  "extends": ["next", "next/core-web-vitals"],
  "rules": {
    "import/order": [
      "warn",
      {
        "groups": ["builtin", "external", "internal", "parent", "sibling", "index"],
        "pathGroups": [
          {
            "pattern": "react",
            "group": "external",
            "position": "before"
          }
        ],
        "pathGroupsExcludedImportTypes": ["react"],
        "newlines-between": "always",
        "alphabetize": {
          "order": "asc",
          "caseInsensitive": true
        }
      }
    ],
    "react-hooks/exhaustive-deps": "off"
  }
}'
