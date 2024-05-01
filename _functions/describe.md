---
title: Describe
---

Get object outline

```jq
def describe:
  walk(
    if (type == "object" or type == "array")
    then (if (type == "array") then ([limit(1;.[])]) else . end)
    else (
      if (type == "string") and (test("^https?"))
      then "url"
      else ((.|fromdate|"date")? // type)
      end
      )
    end
  );
```

```console
$ jq 'include "recipes"; describe' data/sample-github-events.json
[
  {
    "id": "string",
    "type": "string",
    "actor": {
      "id": "number",
      "login": "string",
      "display_login": "string",
      "gravatar_id": "string",
      "url": "url",
      "avatar_url": "url"
    },
    "repo": {
      "id": "number",
      "name": "string",
      "url": "url"
    },
    "payload": {
      "ref": "string",
      "ref_type": "string",
      "master_branch": "string",
      "description": "null",
      "pusher_type": "string"
    },
    "public": "boolean",
    "created_at": "date"
  }
]
```
