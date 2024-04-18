---
---

# Oneliners

## Recursively convert appropriate data types from string

input: [ "true", "11", "hello", null ]  
output: [ true, 11, "hello", null ]

```jq
walk( fromjson? // .)
```

## Combine json files

```sh
jq -n 'reduce inputs as $s (.; .[input_filename|gsub(".json";"")|split("/")|last] += $s)' ./*.json
```

## Simple groupby

```jq
group_by(.[$key]) | map({"\(.[0][$key])": length}) | add
```

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

```jq
paths(scalars) as $p | "\($p|join("."))=\(getpath($p))"
```

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

## Extract multiple fields

```jq
( paths(scalars) | select(IN(.[];
  "_index",
  "current_send_data",
  "ship_send_delay",
  "ship_send_priority",
  "current_ship_status"
))) as $p
| "\($p|join("."))=\(getpath($p))"
```

```console
$ jq -r 'paths(scalars) as $p | "\($p|join("."))=\(getpath($p))"' file
_index=ships
_type=doc
_id=c36806c10a96a3968c07c6a222cfc818
_score=0.057158414
_source.user_email=admin@example.com
_source.current_send_date=1552557382
_source.next_send_date=1570798063
_source.data_name=atari
_source.statistics.game_mode=engineer
_source.statistics.opened_game=0
_source.statistics.user_score=0
_source.statistics.space_1.ship_send_priority=10
_source.statistics.space_1.ssl_required=true
_source.statistics.space_1.ship_send_delay=15
_source.statistics.space_1.user_score=0
_source.statistics.space_1.template1.current_ship_status=sent
_source.statistics.space_1.template1.current_ship_date=4324242
_source.statistics.space_1.template1.checked_link_before_clicked=0
_source.statistics.space_1.template2.current_ship_status=sent
_source.statistics.space_1.template2.current_ship_date=4324242
_source.statistics.space_1.template2.checked_payload=0
```

[[Source]](https://stackoverflow.com/a/55277881)
