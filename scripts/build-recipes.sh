#!/usr/bin/env bash
# shellcheck disable=SC2046

JQFILE=recipes.jq
SCRIPT=$(realpath $0)

cd ${SCRIPT%/*} || exit 1
cd $(git rev-parse --show-toplevel) || exit 1

BANNER="#
#  INSTALL
#    $ curl -O https://nntrn.github.io/jq-recipes/recipes.jq
#
#  USAGE
#    $ jq 'include \"${JQFILE%.jq}\"; [..] '
#
#  SOURCE
#    https://github.com/nntrn/jq-recipes
#
"

build() {
  echo "$BANNER"
  head -n 1000 $(grep --exclude-dir "_site" --include "*.md" -rlE '^def ' _* | sort) |
    sed 's,^`.*,,g; s,<==$,\n,g' |
    sed -nE '/^==>|^def/,/^$/p' | sed 's,^==> ,\n# source: ,g'
}

build | cat -s | tee $JQFILE
jq -nr -L . 'include "recipes"; try error("has error") catch ""'
