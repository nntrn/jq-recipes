---
---

# Reduce

## empty

```console
$ echo 1 2 3 | jq -cn 'reduce inputs as $i ([]; if $i==0 then empty else .+[$i] end)'
[1,2,3]

$ echo 1 2 3 | jq -cn 'reduce inputs as $i ([]; if $i==1 then empty else .+[$i] end)'
[2,3]
```

## sum

```console
$ seq 5 | jq -n 'reduce inputs as $i (0;.+($i|tonumber))'
15
```

## flatten and match string

```console
$ jq --arg match_text "nntrn" '. as $data 
| [path(..| select(scalars and (tostring | test($match_text)))) ] | map({ (.|join(".")): (. as $path | .=$data | getpath($path)) }) 
| reduce .[] as $item ({}; . * $item)' data/sample-github-events.json

{
  "0.actor.login": "nntrn",
  "0.actor.display_login": "nntrn",
  "0.actor.url": "https://api.github.com/users/nntrn",
  "0.repo.name": "nntrn/jq-recipes",
  "0.repo.url": "https://api.github.com/repos/nntrn/jq-recipes"
}
```



Learn more:

- [Reduce in jq on Exercism](https://exercism.org/tracks/jq/concepts/reduce)
- https://stackoverflow.com/a/74687036/7460613
- https://github.com/stedolan/jq/issues/873#issuecomment-125393055