# Examples

## Reduce

**Reduce Inputs**

```console
$ echo 1 2 3 | jq -cn 'reduce inputs as $i ([]; if $i==0 then empty else .+[$i] end)'
[1,2,3]

$ echo 1 2 3 0 | jq -cn 'reduce inputs as $i ([]; if $i==0 then empty else .+[$i] end)'
null
```

[Source](https://github.com/stedolan/jq/issues/873#issuecomment-125393055)

**Reduce sum**

```console
$ seq 5 | jq -n 'reduce inputs as $i (0;.+($i|tonumber))'
15
```

[Source](https://stackoverflow.com/a/74687036/7460613)

## Update-assignment: |=

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

[[Source]](https://github.com/stedolan/jq/issues/873#issuecomment-125385615)
