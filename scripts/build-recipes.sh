#!/usr/bin/env bash
# shellcheck disable=SC2046

RECIPES_PATH=recipes.jq
SCRIPT=$(realpath $0)

cd ${SCRIPT%/*} || cd "$(dirname "$SCRIPT")"
cd $(git rev-parse --show-toplevel) || exit 1

recipes() {
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  local repo=${PWD##*/}

  cd ../
  echo "#"
  echo "# https://github.com/nntrn/jq-recipes"
  echo "#"
  echo "# USAGE"
  echo "#     $ cd ~/.jq"
  echo "#     $ curl -O https://nntrn.github.io/jq-recipes/$RECIPES_PATH"
  echo "#     $ jq 'include \"${RECIPES_PATH%.jq}\"; [funcname]'"
  echo "#"
  echo
  head -n 1000 $(grep --include "*.md" -rlE '^def ' $repo) |
    sed 's,^`.*,,g;s,<==$,<==\n,g' |
    sed -nE '/^==>|^def/,/^$/p' |
    sed -E 's,^==>|<==$,##############################,g'
}

recipes | tee $RECIPES_PATH
