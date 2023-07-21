# Working with streams

Data used: [nested.json](../data/outer.json)

```json
{
  "outer1": {
    "outer2": {
      "outer3": {
        "key1": "value1",
        "key2": "value2"
      },
      "outer4": {
        "key1": "value1",
        "key2": "value2"
      }
    }
  }
}
```

```console
$ jq -c --stream '' data/outer.json

[["outer1","outer2","outer3","key1"],"value1"]
[["outer1","outer2","outer3","key2"],"value2"]
[["outer1","outer2","outer3","key2"]]
[["outer1","outer2","outer4","key1"],"value1"]
[["outer1","outer2","outer4","key2"],"value2"]
[["outer1","outer2","outer4","key2"]]
[["outer1","outer2","outer4"]]
[["outer1","outer2"]]
[["outer1"]]
```
