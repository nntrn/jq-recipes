# Data transformation

## json2ini

Adapted from <a>https://stackoverflow.com/a/76665197</a>

Data used: [nested.json](data/nested.json)

```
{
  "server": {
    "atx": {
      "user": "annie",
      "port": 22
    }
  },
  "storage": {
    "nyc": {
      "user": "nntrn",
      "port": 22
    }
  }
}
```

```sh
jq --stream -nr ' reduce (inputs | select(has(1))) as [$path, $val]
  ( {}; .[$path[:-1] | join(".")][$path[-1]] = $val )
| to_entries[]
| "[\(.key)]", (.value | to_entries[] | "\(.key) = \(.value)" )
, ""'
```

Output

```
[server.atx]
user = annie
port = 22

[storage.nyc]
user = nntrn
port = 22
```

## tsv2json

Adapted from <a>https://stackoverflow.com/a/55996042</a>

Data used: [tmp.tsv](data/tmp.tsv)

```
foo bar baz
1   2   3
4   5   6
```

```sh
jq -R 'split("[\\s\\t]+";"x") as $head
| [inputs | split("[\\s\\t]+";"x")]
| map( . as $row | reduce (keys|.[]) as $x
    ( {}; . + {"\($head[$x])":$row[$x]} ) )' data/tmp.tsv
```

Output

```json
[
  {
    "foo": "1",
    "bar": "2",
    "baz": "3"
  },
  {
    "foo": "4",
    "bar": "5",
    "baz": "6"
  }
]
```
