---
title: Range
---

```console
$ jq -c -n '{x: range(2), y: range(2;5) }'
{"x":0,"y":2}
{"x":0,"y":3}
{"x":0,"y":4}
{"x":1,"y":2}
{"x":1,"y":3}
{"x":1,"y":4}
```