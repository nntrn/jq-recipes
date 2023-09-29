# Wrangle

## Zip Column Headers

```jq
.[0] as $cols
| .[1:]
| map(
  . as $row
  | $cols
  | with_entries({ "key": .value,"value": $row[.key]})
)
```

Input

```json
[
  ["USER", "TTY", "FROM", "LOGIN@", "IDLE", "JCPU", "PCPU", "WHAT"],
  ["lava1", "pts/0", "157.48.149.102", "05:03", "31.00s", "0.31s", "0.31s", "-bash"],
  ["azureuse", "pts/1", "157.48.149.102", "07:26", "0.00s", "0.07s", "0.05s", "w"]
]
```

Result

```json
[
  {
    "USER": "lava1",
    "TTY": "pts/0",
    "FROM": "157.48.149.102",
    "LOGIN@": "05:03",
    "IDLE": "31.00s",
    "JCPU": "0.31s",
    "PCPU": "0.31s",
    "WHAT": "-bash"
  },
  {
    "USER": "azureuse",
    "TTY": "pts/1",
    "FROM": "157.48.149.102",
    "LOGIN@": "07:26",
    "IDLE": "0.00s",
    "JCPU": "0.07s",
    "PCPU": "0.05s",
    "WHAT": "w"
  }
]
```

- ["How to zip arrays with jq and a custom zipping function"](https://stackoverflow.com/a/75829018/7460613) on StackOverflow
- [JQ Wiki Cookbook:](https://github.com/stedolan/jq/wiki/Cookbook#zip-column-headers-with-their-rows) Zip column headers with their rows

## Using Transpose

```jq
def s: [splits(" +")];

[s as $k | inputs | [$k, s] | transpose | map({(.[0]): .[1]}) | add]
```

Input

```
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
lava1    pts/0    157.48.149.102   05:03   31.00s  0.31s  0.31s -bash
azureuse pts/1    157.48.149.102   07:26    0.00s  0.07s  0.05s w
```

Result

```json
[
  {
    "USER": "lava1",
    "TTY": "pts/0",
    "FROM": "157.48.149.102",
    "LOGIN@": "05:03",
    "IDLE": "31.00s",
    "JCPU": "0.31s",
    "PCPU": "0.31s",
    "WHAT": "-bash"
  },
  {
    "USER": "azureuse",
    "TTY": "pts/1",
    "FROM": "157.48.149.102",
    "LOGIN@": "07:26",
    "IDLE": "0.00s",
    "JCPU": "0.07s",
    "PCPU": "0.05s",
    "WHAT": "w"
  }
]
```

[Source](https://stackoverflow.com/a/75839378/7460613)

## Flat string

[energy.json](../data/energy.json)

```jq
paths(scalars) as $p | "\($p|join("."))=\(getpath($p))"
```

```
0.source=Agricultural 'waste'
0.target=Bio-conversion
0.value=124.729
1.source=Bio-conversion
1.target=Liquid
1.value=0.597
2.source=Bio-conversion
2.target=Losses
2.value=26.862
3.source=Bio-conversion
3.target=Solid
3.value=280.322
```

---

## References

- [JQ Wiki Cookbook: Zip column headers with their rows](https://github.com/stedolan/jq/wiki/Cookbook#zip-column-headers-with-their-rows)
