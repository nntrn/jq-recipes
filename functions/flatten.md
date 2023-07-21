# Flatten

## Flat JSON

**Data:** [data/sample-github-events.json](../data/sample-github-events.json)

```jq
def flat_object:
  [paths(scalars) as $path
  | {"key": $path | join("_"), "value": getpath($path)}]
  | from_entries;

def flat_array:
  map( flat_object );
```

```sh
jq 'include "recipes";
map(
  if type == "object"
  then flat_object elif type == "array"
  then flat_array
  else .
  end
)' data/sample-github-events.json
```

Output

```json
[
  {
    "id": "30572272710",
    "type": "CreateEvent",
    "actor_id": 17685332,
    "actor_login": "nntrn",
    "actor_display_login": "nntrn",
    "actor_gravatar_id": "",
    "actor_url": "https://api.github.com/users/nntrn",
    "actor_avatar_url": "https://avatars.githubusercontent.com/u/17685332?",
    "repo_id": 582752600,
    "repo_name": "nntrn/jq-recipes",
    "repo_url": "https://api.github.com/repos/nntrn/jq-recipes",
    "payload_ref": "master",
    "payload_ref_type": "branch",
    "payload_master_branch": "main",
    "payload_pusher_type": "user",
    "public": true,
    "created_at": "2023-07-21T00:01:11Z"
  }
]
```

