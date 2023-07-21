# barcharts

```jq
def barchart($key):
  length as $total
  | map((.[$key] // "null") | tostring)
  | group_by(.)
  | (map({ key: .[0], value: length, title_len: (.[0]|tostring|length) }) ) as $columns
  | $columns
  | sort_by(.value) | reverse
  | (max_by(.title_len)|.title_len) as $padding
  |
  (if (((($columns|length)/$total) > .8) or (($columns|length) > 1000)) then
    [ "IGNORING <\($key)>: \($columns|length) out of \($total) rows", ""]
  else [
    $key,
    ("-" * ($key|length) ),
    map(
    [
      .key, (" " * ($padding-.title_len)),
      "\((.value/$total)*100|tostring|.+".000"|.[0:4])%",
      ( if (.value == 1) then "▊" else ("█" * (((.value/$total)*100) + (.value|log)|round)) end),
      .value
    ] | join(" ")
    ),
    ""
  ] end)
  | flatten
  | join("\n");

def generate:
  . as $data
  | (.[0]|keys) as $cols
  | ($cols | map(. as $col | $data | barchart($col)) | join("\n")) as $barcharts
  | [
      $barcharts,
      "",
      "+" * (($barcharts|split("\n")|max_by(length))|length),
      "data from \(input_filename)",
       "+" * (($barcharts|split("\n")|max_by(length))|length)
    ]
  | flatten| join("\n")
;
```

```sh
$ curl -O https://raw.githubusercontent.com/nntrn/jq-recipes/docs/data/titanic.json
$ jq -r 'include "barcharts"; generate' titanic.json
```
```
Parents_Children_Aboard
-----------------------
0  75.9% ██████████████████████████████████████████████████████████████████████████████████ 674
1  13.3% ██████████████████ 118
2  9.01% █████████████ 80
5  0.56% ██ 5
3  0.56% ██ 5
4  0.45% █ 4
6  0.11% ▊ 1

Pclass
------
3  54.9% █████████████████████████████████████████████████████████████ 487
1  24.3% █████████████████████████████ 216
2  20.7% █████████████████████████ 184

Sex
---
male    64.5% ██████████████████████████████████████████████████████████████████████ 573
female  35.4% █████████████████████████████████████████ 314

Siblings_Spouses_Aboard
-----------------------
0  68.0% ██████████████████████████████████████████████████████████████████████████ 604
1  23.5% ████████████████████████████ 209
2  3.15% ██████ 28
4  2.02% ████ 18
3  1.80% ████ 16
8  0.78% ██ 7
5  0.56% ██ 5

Survived
--------
0  61.4% ███████████████████████████████████████████████████████████████████ 545
1  38.5% ████████████████████████████████████████████ 342


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
data from data/titanic.json
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
```
