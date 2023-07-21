# Flatten

## Flat JSON

```jq
# ~/.jq/flatten.jq

def flat_object: [paths(scalars) as $path | {"key": $path | join("_"), "value": getpath($path)}] | from_entries;

def flat_array: map( flat_object );

map(if type == "object" then flat_object elif type == "array" then flat_array else . end)
```

<details><summary>Before</summary>
<pre>$ curl -s 'https://api.github.com/users/nntrn/received_events?per_page=2'
[
  {
    "id": "28961266369",
    "type": "WatchEvent",
    "actor": {
      "id": 25425933,
      "login": "saiemgilani",
      "display_login": "saiemgilani",
      "gravatar_id": "",
      "url": "https://api.github.com/users/saiemgilani",
      "avatar_url": "https://avatars.githubusercontent.com/u/25425933?"
    },
    "repo": {
      "id": 505216695,
      "name": "jakeyk11/football-data-analytics",
      "url": "https://api.github.com/repos/jakeyk11/football-data-analytics"
    },
    "payload": {
      "action": "started"
    },
    "public": true,
    "created_at": "2023-05-10T02:50:47Z"
  }
]</pre>
</details>

<details><summary>After</summary>
<pre>$ curl -s 'https://api.github.com/users/nntrn/received_events?per_page=1' | jq -f ~/.jq/flatten.jq
[
  {
    "id": "28961266369",
    "type": "WatchEvent",
    "actor_id": 25425933,
    "actor_login": "saiemgilani",
    "actor_display_login": "saiemgilani",
    "actor_gravatar_id": "",
    "actor_url": "https://api.github.com/users/saiemgilani",
    "actor_avatar_url": "https://avatars.githubusercontent.com/u/25425933?",
    "repo_id": 505216695,
    "repo_name": "jakeyk11/football-data-analytics",
    "repo_url": "https://api.github.com/repos/jakeyk11/football-data-analytics",
    "payload_action": "started",
    "public": true,
    "created_at": "2023-05-10T02:50:47Z"
  }
]</pre>
</details>

