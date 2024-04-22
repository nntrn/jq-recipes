---
source: https://github.com/stedolan/jq/issues/873#issuecomment-125385615
---

# Update assignment

## |=

```json
{
  "key1": {
    "attr1": "foo"
  },
  "key2": {
    "attr1": "foo",
    "attr2": "bar"
  }
}
```

```console
$ jq '.[] |= if .attr2 then (.attr2 = "bax") else . end'
{
  "key1": {
    "attr1": "foo"
  },
  "key2": {
    "attr1": "foo",
    "attr2": "bax"
  }
}
```
