#
#  INSTALL
#    $ curl -O https://nntrn.github.io/jq-recipes/recipes.jq
#
#  USAGE
#    $ jq 'include "recipes"; [..] '
#
#  SOURCE
#    https://github.com/nntrn/jq-recipes
#

##########################################################################################
# functions/barcharts.md  
##########################################################################################

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

def run_barchart:
  . as $data
  | (.[0]|keys) as $cols
  | ($cols | map(. as $col | $data | barchart($col)) | join("\n")) as $barcharts
  | [ $barcharts ]
  | flatten| join("\n")
;

##########################################################################################
# functions/conversion.md  
##########################################################################################

def to_precision($p):
  . |tostring|split(".")
  | [.[0], (.[1]|split("")|.[0:($p|tonumber)]|join(""))]
  | join(".")
  | tonumber;

def humansize(bytes;$p):
  (bytes|tonumber) as $size |
  if   $size > 1073741824 then "\(($size/1073741824)|to_precision($p))G"
  elif $size > 1048576    then "\(($size/1048576)|to_precision($p))M"
  elif $size > 1024       then "\(($size/1024)|to_precision($p))K"
  else $size
  end;

def humansize(bytes): humansize(bytes;1);

##########################################################################################
# functions/describe.md  
##########################################################################################

def describe:
  walk(
    if (type == "object" or type == "array")
    then (if (type == "array") then ([limit(1;.[])]) else . end)
    else (
      if (type == "string") and (test("^https?"))
      then "url"
      else ((.|fromdate|"date")? // type)
      end
      )
    end
  );

##########################################################################################
# functions/flatten.md  
##########################################################################################

def flat_object:
  [paths(scalars) as $path
  | {"key": $path | join("_"), "value": getpath($path)}]
  | from_entries;

def flat_array:
  map( flat_object );

##########################################################################################
# functions/github-api.md  
##########################################################################################

def github_raw_url:
  [
    "curl --create-dirs -o \(.repository.full_name)/\(.path) ",
    (.html_url|gsub("/github.com";"/raw.githubusercontent.com")|gsub("/blob/"; "/")),
    (if .repository.private then " -H \"Authorization: Bearer $GITHUB_TOKEN\"" else "" end)
  ] | join("");

##########################################################################################
# functions/json2csv.md  
##########################################################################################

def json2csv:
  (map(keys) | add | unique) as $cols
  | map(. as $row | $cols | map($row[.])) as $rows
  | $cols, $rows[]
  | @csv;

##########################################################################################
# functions/pick.md  
##########################################################################################

def pick(stream):
  . as $in
  | reduce path(stream) as $a (null;
      setpath($a; $in|getpath($a)) );

##########################################################################################
# functions/read-history.md  
##########################################################################################

def history:
  map(
    if test("#[0-9]{10,12}")
    then "\(.|gsub("#";"")|tonumber|todate)"
    else "\t\(.)\n"
    end
  ) | join("");

##########################################################################################
# functions/summary.md  
##########################################################################################

def grouped_summary($item):
  {"\($item? // "blank")":group_by(.[$item])|map({"\(.[0][$item]? // "blank")":length})|add};

def summary:
  [ (.[0]|keys)[] as $keys | grouped_summary($keys)]
  | add
  | to_entries
  | map(
      del(select(((.value//"")|keys[0]|length) > 100)) |
      del(select(((.value//"")|values|length) > 400))
    )
  | map(select(.))
  | from_entries;

def summary_wip:
  [ (.[0]|keys)[] as $keys | grouped_summary($keys)]
  | add
  | to_entries
  #| map(del(select(((.value//"")|keys|length) > 400)))
  | map(select(.)|{key,count:(.value|length)})
  | map(.value |= to_entries);

def summary2:
  . as $data
  | (.[0]|keys)
  | map(. as $item | {
      key: $item,
      value: ($data|map(.[$item])|group_by(.)|map({"\(.[0])": length}))|add
    })
  | map(select((.value|to_entries|length)< (.90 * ($data|length))))
  | from_entries;

##########################################################################################
# general/codepoints.md  
##########################################################################################

def smart_squotes($s):
  $s | if (test("[\\s\\n\\t]";"x")) then "\([39]|implode)\($s)\([39]|implode)" else $s end;

def smart_dquotes($s):
  $s | if (test("[\\s\\n\\t]";"x")) then "\($s|@json)" else $s end;

##########################################################################################
# general/reduce.md  
##########################################################################################

def tocsv:
  .[0] as $cols | .[1:]
  | map(. as $row
  | $cols
  | with_entries({ "key": .value,"value": $row[.key]})
  );

##########################################################################################
# general/wrangle.md  
##########################################################################################

def s: [splits(" +")];

