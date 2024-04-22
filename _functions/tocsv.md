---
---

# tocsv

```jq
def tocsv:
  .[0] as $cols | .[1:]
  | map(. as $row
  | $cols
  | with_entries({ "key": .value,"value": $row[.key]})
  );
```

```sh
jq 'reduce inputs as $s (.;
  .[input_filename] += ($s|gsub("\r";"")|gsub("\"";"")|split("\n")|map(split(",")))
) | with_entries(.value|= tocsv)' PROFILES/*.csv
```