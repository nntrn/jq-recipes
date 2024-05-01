---
title: Github API
---

```jq
def github_raw_url:
  [
    "curl --create-dirs -o \(.repository.full_name)/\(.path) ",
    (.html_url|gsub("/github.com";"/raw.githubusercontent.com")|gsub("/blob/"; "/")),
    (if .repository.private then " -H \"Authorization: Bearer $GITHUB_TOKEN\"" else "" end)
  ] | join("");
```

```sh
eval "$(
  curl -s -H "Authorization: Bearer $GITHUB_TOKEN" 'https://api.github.com/search/code?per_page=3&q=language:shell+user:nntrn+NOT+is:fork' |
    jq -r 'include "recipes"; .items|map(github_raw_url)|join("\n")'
)"
```
