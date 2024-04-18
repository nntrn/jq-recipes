---
---

# json2csv

```jq
# ~/.jq/convert.jq

def json2csv:
  (map(keys) | add | unique) as $cols
  | map(. as $row | $cols | map($row[.])) as $rows
  | $cols, $rows[]
  | @csv;
```

```console
$ curl -s -o todos.json https://jsonplaceholder.typicode.com/todos
$ jq 'include "convert"; json2csv' todos.json

"completed","id","title","userId"
false,1,"delectus aut autem",1
false,2,"quis ut nam facilis et officia qui",1
false,3,"fugiat veniam minus",1
true,4,"et porro tempora",1
false,5,"laboriosam mollitia et enim quasi adipisci quia provident illum",1
false,6,"qui ullam ratione quibusdam voluptatem quia omnis",1
false,7,"illo expedita consequatur quia in",1
true,8,"quo adipisci enim quam ut ab",1
```
