---
---

# Text functions

## Recursively split strings w/ new lines

```jq
def split_newlines($s): 
  if ((type == "string") and (($s|tostring|split("\n")|length) > 1)?) 
  then ($s|tostring|split("[\\r\\n]+([\\s]+)?";"x")) 
  elif (type == "object") then to_entries 
  else $s end; 

def recuse_split_newlines: walk(split_newlines(.)|from_entries? // .);
```

## Quoting

```jq
def squo: [39]|implode;

def squote($text): [squo,$text,squo]|join("");
def dquote($text): "\"\($text)\"";

def unsmart($text): $text | gsub("[“”]";"\"") | gsub("[’‘]";"'");
def unsmart: . | unsmart;
```

## Cleaning up text


Remove repeated special characters using `\\1` (such as `[[`, `{{`, `'''`)

```jq
gsub("([^\\w\\d\\s])\\1(\\1)?";"")
```
```console
$ cat wikitext.txt
{{Date table sorting|December 31}}
[[Charlotte, North Carolina|Charlotte]] (4)
[[North Carolina]]
'''5'''

$ jq -rR 'gsub("([^\\w\\d\\s])\\1(\\1)?";"")' gsub.txt
Date table sorting|December 31
Charlotte, North Carolina|Charlotte (4)
North Carolina
5
```