#!/usr/bin/env bash
# shellcheck disable=SC2046

SCRIPT=$(realpath $0)

cd ${SCRIPT%/*} || exit 1
cd $(git rev-parse --show-toplevel) || exit 1

JQFILE=recipes.jq

GHPAGE_URL=https://nntrn.github.io/jq-recipes

BORDER="##########################################################################################"

BANNER="#
#  INSTALL
#    $ curl --create-dirs -o ~/.jq/recipes.jq ${GHPAGE_URL}/${JQFILE}
#
#  USAGE
#    $ jq 'include \"${JQFILE%.jq}\"; [..] '
#"

build() {
  echo "$BORDER"
  echo "$BANNER"
  echo "$BORDER"
  head -n 1000 $(grep --include "*.md" -rlE '^def ' .) |
    sed 's,^`.*,,g; s,<==$,\n,g' |
    sed -nE '/^==>|^def/,/^$/p' |
    sed -E 's,^==> \./(.*)$,<BORDER>\n# \1 \n<BORDER>,g' |
    sed "s,<BORDER>,$BORDER,g"
}

build | tee $JQFILE
jq -nr -L . 'include "recipes"; try error("has error") catch ""'
