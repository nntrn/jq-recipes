---
title: Scalars
---

Scalars are variables that hold an *individual* value (strings, integers, and booleans). If it's not an object or array &mdash; it's most likely a scalar

{:data}
[sample-github-events.json](../data/sample-github-events.json)


## Extract

```jq
map(with_entries(select(.value|scalars)))
```

## Flatten

```jq
. as $data
| [path(..|select(scalars))]
| map({ (.|join(".")): (. as $path | .=$data | getpath($path)) })
| add
```

```console
$ jq '. as $data | [path(..| select(scalars))] | map({ (.|join(".")): (. as $path | .=$data | getpath($path)) }) | add' sample-github-events.json

{
  "0.id": "30572272710",
  "0.type": "CreateEvent",
  "0.actor.id": 17685332,
  "0.actor.login": "nntrn",
  "0.actor.display_login": "nntrn",
  "0.actor.gravatar_id": "",
  "0.actor.url": "https://api.github.com/users/nntrn",
  "0.actor.avatar_url": "https://avatars.githubusercontent.com/u/17685332?",
  "0.repo.id": 582752600,
  "0.repo.name": "nntrn/jq-recipes",
  "0.repo.url": "https://api.github.com/repos/nntrn/jq-recipes",
  "0.payload.ref": "master",
  "0.payload.ref_type": "branch",
  "0.payload.master_branch": "main",
  "0.payload.pusher_type": "user",
  "0.public": true,
  "0.created_at": "2023-07-21T00:01:11Z"
}
```

## Target URLs

Select paths that begin with `https://`

```jq
. as $data
| [path(..| select(scalars and (tostring | test("^https://";"x"))))]
| map({ (.|join(".")): (. as $path | .=$data | getpath($path)) })
| add
```

```console
$ jq '. as $data | [path(..| select(scalars and (tostring | test("^https://";"x"))))] | map({ (.|join(".")): (. as $path | .=$data | getpath($path)) })|add' sample-github-events.json

{
  "0.actor.url": "https://api.github.com/users/nntrn",
  "0.actor.avatar_url": "https://avatars.githubusercontent.com/u/17685332?",
  "0.repo.url": "https://api.github.com/repos/nntrn/jq-recipes"
}
```

---

Adapted from [5 Useful jq Commands to Parse JSON on the CLI](https://www.fabian-keller.de/blog/5-useful-jq-commands-parse-json-cli/):


### path
now with \``..`\`, traverse with `path`

```console
$ jq -c '. as $data | [path(..)][]' sample-github-events.json

[]
[0]
[0,"id"]
[0,"type"]
[0,"actor"]
[0,"actor","id"]
[0,"actor","login"]
[0,"actor","display_login"]
[0,"actor","gravatar_id"]
[0,"actor","url"]
[0,"actor","avatar_url"]
[0,"repo"]
[0,"repo","id"]
[0,"repo","name"]
[0,"repo","url"]
[0,"payload"]
[0,"payload","ref"]
[0,"payload","ref_type"]
[0,"payload","master_branch"]
[0,"payload","description"]
[0,"payload","pusher_type"]
[0,"public"]
[0,"created_at"]
```

### select
Select only paths that contain `nntrn` (github username) in the value

```console
$ jq -c '. as $data | [path(..| select(scalars and (tostring | test( "nntrn")))) ][]' sample-github-events.json

[0,"actor","login"]
[0,"actor","display_login"]
[0,"actor","url"]
[0,"repo","name"]
[0,"repo","url"]
```

### getpath

```console
$ jq '. as $data | [path(..| select(scalars and (tostring | test("nntrn")))) ] | map({ (.|join(".")): (. as $path | .=$data | getpath($path)) })' data/sample-github-events.json

[
  {
    "0.actor.login": "nntrn"
  },
  {
    "0.actor.display_login": "nntrn"
  },
  {
    "0.actor.url": "https://api.github.com/users/nntrn"
  },
  {
    "0.repo.name": "nntrn/jq-recipes"
  },
  {
    "0.repo.url": "https://api.github.com/repos/nntrn/jq-recipes"
  }
]
```

### reduce
`reduce` all key-value matches to a single object

```console
$ jq '. as $data | [path(..| select(scalars and (tostring | test("nntrn")))) ] | map({ (.|join(".")): (. as $path | .=$data | getpath($path)) }) | reduce .[] as $item ({}; . * $item)' data/sample-github-events.json

{
  "0.actor.login": "nntrn",
  "0.actor.display_login": "nntrn",
  "0.actor.url": "https://api.github.com/users/nntrn",
  "0.repo.name": "nntrn/jq-recipes",
  "0.repo.url": "https://api.github.com/repos/nntrn/jq-recipes"
}
```

### add
`add` can also be used in this case

```console
$ jq '. as $data | [path(..| select(scalars and (tostring | test("nntrn")))) ] | map({ (.|join(".")): (. as $path | .=$data | getpath($path)) })|add' data/sample-github-events.json

{
  "0.actor.login": "nntrn",
  "0.actor.display_login": "nntrn",
  "0.actor.url": "https://api.github.com/users/nntrn",
  "0.repo.name": "nntrn/jq-recipes",
  "0.repo.url": "https://api.github.com/repos/nntrn/jq-recipes"
}
````
