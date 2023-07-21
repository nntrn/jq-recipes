# Codepoints

Work with explode/implode

## Smart quotes

Wrap string with quotes when a space, new line, or tab is present

```jq
# single quote
def smart_squotes($s): $s | if (test("[\\s\\n\\t]";"x")) then "\([39]|implode)\($s)\([39]|implode)" else $s end;

# double quote
def smart_dquotes($s): $s | if (test("[\\s\\n\\t]";"x")) then "\($s|@json)" else $s end;
```
```console
$ jq -n -r '["hello","hello world","hello\nworld","hello\tworld"] | map("var="+smart_squotes(.))[]'
var=hello
var='hello world'
var='hello
world'
var='hello      world'

$ jq -n -r '["hello","hello world","hello\nworld","hello\tworld"] | map("var="+smart_dquotes(.))[]'
var=hello
var="hello world"
var="hello\nworld"
var="hello\tworld"
```

## Chart

```sh
jq -n -r '[range(9622;9632)]|map("\(.) \([.]|implode)")[]'
```
```console
$ jq -n -r '[range(9622;9632)]|map("\(.) \([.]|implode)")[]'
9622 ▖
9623 ▗
9624 ▘
9625 ▙
9626 ▚
9627 ▛
9628 ▜
9629 ▝
9630 ▞
9631 ▟
```
