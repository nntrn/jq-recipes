# summary

```jq
def grouped_summary($item):
  {"\($item)":group_by(.[$item])|map({"\(.[0][$item])":length})|add};

def summary:
  [ (.[0]|keys)[] as $keys | grouped_summary($keys)]
  | add
  | to_entries
  | map(
      del(select(((.value//"")|keys[0]|length) > 100)) |
      del(select(((.value//"")|keys|length) > 400))
    )
  | map(select(.))
  | from_entries;

def summary_wip:
  [ (.[0]|keys)[] as $keys | grouped_summary($keys)]
  | add
  | to_entries
  #| map(del(select(((.value//"")|keys|length) > 400)))
  | map(select(.)|{key,count:(.value|length)})
  #| map(.value |= to_entries);

# possibly a better solution
def summary2:
  . as $data
  | (.[0]|keys)
  | map(. as $item | {
      key: $item,
      value: ($data|map(.[$item])|group_by(.)|map({"\(.[0])": length}))|add
    })
  | map(select((.value|to_entries|length)< (.90 * ($data|length))))
  | from_entries;
```

```console
$ jq 'include "recipes"; summary2' data/titanic2.json
{
  "Parents_Children_Aboard": {
    "0": 674,
    "1": 118,
    "2": 80,
    "3": 5,
    "4": 4,
    "5": 5,
    "6": 1
  },
  "Pclass": {
    "1": 216,
    "2": 184,
    "3": 487
  },
  "Sex": {
    "female": 314,
    "male": 573
  },
  "Siblings_Spouses_Aboard": {
    "0": 604,
    "1": 209,
    "2": 28,
    "3": 16,
    "4": 18,
    "5": 5,
    "8": 7
  },
  "Survived": {
    "0": 545,
    "1": 342
  }
}
```

