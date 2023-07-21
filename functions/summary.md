# summary

```jq
# ~/.jq/summary.jq

def grouped_summary($item):
  {"\($item)":group_by(.[$item])|map({"\(.[0][$item])":length})|add};

def summary:
  [(.[0]|keys)[] as $keys | grouped_summary($keys)]
  | add
  | to_entries
  | map(del(select((.value|keys[0]|length) > 100 )) | del(select((.value|keys|length) > 400 )))
  | map(select(.))
  | from_entries;

# possibly a better way
def summary2:
  . as $data
  | (.[0]|keys)
  | map(. as $item| {key: $item, value: ($data|map(.[$item])|group_by(.)|map({"\(.[0])": length}) )|add } )
  | map(select((.value|to_entries|length)< (.90 * ($data|length)) ));
```


```console
$ jq -L $HOME/.jq 'include "summary"; summary' data/titanic.json

{
  "Age": {
    "0": 1,
    "1": 13,
    "2": 11,
    "3": 7,
    "4": 11,
    "5": 6,
    "6": 3,
    "7": 5,
    "8": 6,
    "9": 8,
    "10": 2,
    "11": 4,
    "12": 2,
    "13": 2,
    "14": 7,
    "15": 6,
    "16": 20,
    "17": 16,
    "18": 36,
    "19": 33,
    "20": 23,
    "21": 35,
    "22": 39,
    "23": 25,
    "24": 35,
    "25": 25,
    "26": 21,
    "27": 26,
    "28": 37,
    "29": 27,
    "30": 33,
    "31": 21,
    "32": 21,
    "33": 19,
    "34": 17,
    "35": 22,
    "36": 23,
    "37": 13,
    "38": 12,
    "39": 18,
    "40": 18,
    "41": 11,
    "42": 17,
    "43": 7,
    "44": 9,
    "45": 14,
    "46": 8,
    "47": 10,
    "48": 12,
    "49": 8,
    "50": 10,
    "51": 7,
    "52": 6,
    "53": 1,
    "54": 9,
    "55": 3,
    "56": 5,
    "57": 3,
    "58": 5,
    "59": 2,
    "60": 5,
    "61": 3,
    "62": 5,
    "63": 2,
    "64": 3,
    "65": 3,
    "66": 2,
    "69": 1,
    "70": 2,
    "71": 3,
    "74": 1,
    "80": 1
  },
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
