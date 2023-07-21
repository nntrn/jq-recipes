# describe

Get object outline


```jq
# ~/.jq/describe.jq

def describe:
  walk(
    if (type == "object" or type == "array")
    then (if (type == "array") then ([limit(1;.[])]) else . end)
    else (if (type == "string") and (test("^https?")) then "url" else ((.|fromdate|"date")? // type) end)
    end
  );
```

```console
$ curl -s -o user.json https://api.github.com/users/nntrn

$ jq 'include "describe"; describe' user.json

{
  "login": "string",
  "id": "number",
  "node_id": "string",
  "avatar_url": "url",
  "gravatar_id": "string",
  "url": "url",
  "html_url": "url",
  "followers_url": "url",
  "following_url": "url",
  "gists_url": "url",
  "starred_url": "url",
  "subscriptions_url": "url",
  "organizations_url": "url",
  "repos_url": "url",
  "events_url": "url",
  "received_events_url": "url",
  "type": "string",
  "site_admin": "boolean",
  "name": "null",
  "company": "null",
  "blog": "string",
  "location": "string",
  "email": "null",
  "hireable": "null",
  "bio": "string",
  "twitter_username": "null",
  "public_repos": "number",
  "public_gists": "number",
  "followers": "number",
  "following": "number",
  "created_at": "date",
  "updated_at": "date"
}
```
