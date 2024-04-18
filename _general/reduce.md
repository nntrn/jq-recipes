---
---

# Reduce

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

| #   | state | element | reducer | result |
| --- | ----- | ------- | ------- | ------ |
| 1   | 0     | 10      | 0 + 10  | 10     |
| 2   | 10    | 20      | 10 + 20 | 30     |
| 3   | 30    | 30      | 30 + 30 | 60     |
| 4   | 60    | 40      | 60 + 40 | 100    |

Learn more:

- [Reduce in jq on Exercism](https://exercism.org/tracks/jq/concepts/reduce)
