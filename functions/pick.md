# pick

[[Source]](https://github.com/jqlang/jq/issues/2578#issuecomment-1532632453)

```jq
# stream should be a stream of dot-paths
def pick(stream):
  . as $in
  | reduce path(stream) as $a (null;
      setpath($a; $in|getpath($a)) );
```

DATA: [simple-nest.json](../data/simple-nest.json)

```console
$ jq 'include "recipes"; pick(.a.d.e)' data/simple-nest.json
{
  "a": {
    "d": {
      "e": 2
    }
  }
}
```

DATA: [api-extractor.schema.json](../data/api-extractor.schema.json)
```console
$ jq 'include "recipes"; pick(.properties.dtsRollup.type)' data/api-extractor.schema.json
{
  "properties": {
    "dtsRollup": {
      "type": "object"
    }
  }
}
```

