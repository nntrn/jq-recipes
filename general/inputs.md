# Working with `inputs`

**DATA**: [tmp.tsv](../data/tmp.tsv)

```console
$ jq -R 'inputs' data/tmp.tsv

"1   2   3"
"4   5   6"
```

```console
$  jq -c -R 'split("[\\s\\t]+";"x")' data/tmp.tsv

["foo","bar","baz"]
["1","2","3"]
["4","5","6"]
```

```console
$ jq -R 'split("[\\s\\t]+";"x") as $h | [$h,inputs]' data/tmp.tsv

[
  [
    "foo",
    "bar",
    "baz"
  ],
  "1   2   3",
  "4   5   6"
]
```
