# conversion

Pretty print numbers

```jq
def to_precision($p):
  . |tostring|split(".")
  | [.[0], (.[1]|split("")|.[0:($p|tonumber)]|join(""))]
  | join(".") 
  | tonumber;

def humansize(bytes):
  (bytes|tonumber) as $size |
  if   $size > 1073741824 then "\(($size/1073741824)|to_precision(1))G"
  elif $size > 1048576    then "\(($size/1048576)|to_precision(1))M"
  elif $size > 1024       then "\(($size/1024)|to_precision(1))K"
  else $size
  end; 
```

Examples

```console
$ jq -nr 'include "recipes"; humansize(45992)'
44.9K

$ jq -nr 'include "recipes"; humansize(301818073)'
287.8M

$ jq -nr 'include "recipes"; humansize(3018180739)'
2.8G
```
