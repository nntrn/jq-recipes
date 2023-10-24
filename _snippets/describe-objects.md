---
title: Object transform
description: Recursively describe objects 
source: https://stackoverflow.com/a/77322330
input: data/type.json
output: |
  [{"name":"id","type":"number","value":123456},
  {"name":"name","type":"string","value":"Test"},
  {"name":"arraySimple","type":"array","value":[1,2,3]},
  {"name":"arrayComplex","type":"array","value":[{"id":38392}]},
  {"name":"instance","type":"object","value":[{"name":"id","type":"number","value":8310}]},
  {"name":"isEmpty","type":"boolean","value":false},
  {"name":"empty","type":"null","value":null}]
---

def describef: {
  type: type,
  value : (objects |= (to_entries | map({name: .key} + (.value | describef))))
};
describef.value
