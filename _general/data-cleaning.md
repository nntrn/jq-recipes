---
---

# Data cleaning

## Delete keys

```sh
jq 'delpaths([paths | select(.[-1] | strings | test("<REGEX>"; "i"))])'
```

## Combine json files

```sh
jq -n 'reduce inputs as $s (.; .[input_filename|gsub(".json";"")|split("/")|last] += $s)' ./*.json
```

## Simple groupby

```sh
jq --arg key value 'group_by(.[$key]) | map({"\(.[0][$key])": length}) | add'
```

Example:

```console
$ jq --arg key Status 'group_by(.[$key]) | map({"\(.[0][$key])": length}) | add'
{
  "Disabled": 35,
  "Ready": 191,
  "Running": 2,
  "Status": 99
}
```

## Flatten json

```sh
jq -r 'paths(scalars) as $p | "\($p|join("."))=\(getpath($p))"' <FILE>
```

Example:

```console
$ jq -r 'paths(scalars) as $p | "\($p|join("."))=\(getpath($p))"' data/titanic.json
0.Survived=0
0.Pclass=3
0.Name=Mr. Owen Harris Braund
0.Sex=male
0.Age=22
0.Siblings_Spouses_Aboard=1
0.Parents_Children_Aboard=0
1.Survived=1
1.Pclass=1
1.Name=Mrs. John Bradley (Florence Briggs Thayer) Cumings
1.Sex=female
1.Age=38
1.Siblings_Spouses_Aboard=1
1.Parents_Children_Aboard=0
```

[[Source]](https://stackoverflow.com/a/55277881)
