#!/usr/bin/env bash
# shellcheck disable=SC2046

SCRIPT=$(realpath $0)

cd ${SCRIPT%/*} || exit 1
cd $(git rev-parse --show-toplevel) || exit 1

RECIPES_PATH=recipes.jq

recipes() {
  BORDER="###########################################################################"
  echo "#
#   INSTALL
#     $ mkdir -p ~/.jq && cd \$_
#     $ curl -O https://nntrn.github.io/jq-recipes/${RECIPES_PATH}
#
#   USAGE
#     $ jq 'include \"${RECIPES_PATH%.jq}\"; [..] '
#
"
  head -n 1000 $(grep --include "*.md" -rlE '^def ' .) |
    sed 's,^`.*,,g; s,<==$,\n,g' |
    sed -nE '/^==>|^def/,/^$/p' |
    sed -E 's,^==> \./(.*)$,<BORDER>\n# \1 \n<BORDER>,g' |
    sed "s,<BORDER>,$BORDER,g"
}

recipes | tee $RECIPES_PATH
