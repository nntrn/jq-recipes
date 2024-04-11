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

# source: _functions/barcharts.md 

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

# source: _functions/conversion.md 

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

# source: _functions/describe.md 

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

# source: _functions/flatten.md 

def flat_object:
  [paths(scalars) as $path
  | {"key": $path | join("_"), "value": getpath($path)}]
  | from_entries;

def flat_array:
  map( flat_object );

# source: _functions/github-api.md 

def github_raw_url:
  [
    "curl --create-dirs -o \(.repository.full_name)/\(.path) ",
    (.html_url|gsub("/github.com";"/raw.githubusercontent.com")|gsub("/blob/"; "/")),
    (if .repository.private then " -H \"Authorization: Bearer $GITHUB_TOKEN\"" else "" end)
  ] | join("");

# source: _functions/json2csv.md 

def json2csv:
  (map(keys) | add | unique) as $cols
  | map(. as $row | $cols | map($row[.])) as $rows
  | $cols, $rows[]
  | @csv;

# source: _functions/pick.md 

def pick(stream):
  . as $in
  | reduce path(stream) as $a (null;
      setpath($a; $in|getpath($a)) );

def spick($key): 
  getpath([($key|split(".")[]|select(length > 0))]);

# source: _functions/read-history.md 

def history:
  map(
    if test("#[0-9]{10,12}")
    then "\(.|gsub("#";"")|tonumber|todate)"
    else "\t\(.)\n"
    end
  ) | join("");

# source: _functions/summary.md 

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

# source: _functions/text.md 

def split_newlines($s): 
  if ((type == "string") and (($s|tostring|split("\n")|length) > 1)?) 
  then ($s|tostring|split("[\\r\\n]+([\\s]+)?";"x")) 
  elif (type == "object") then to_entries 
  else $s end; 

def recuse_split_newlines: walk(split_newlines(.)|from_entries? // .);

def squo: [39]|implode;

def squote($text): [squo,$text,squo]|join("");
def dquote($text): "\"\($text)\"";

def unsmart($text): $text | gsub("[“”]";"\"") | gsub("[’‘]";"'");
def unsmart: . | unsmart;

# source: _functions/unroll.md 

def categorize:
  # Returns "object", "array" or "scalar" to indicate the category
  # of the piped element.
  if type == "object" then "object"
  elif type == "array" then "array"
  else "scalar"
  end;

def pluck($category):
  # Plucks the children of a particular category from piped element.
  if categorize != "object"
  then empty
  else to_entries[]
    | select(.value | categorize == $category)
    | .value
  end;

def split:
  # Splits the piped element's children into arrays, scalars, and objects
  # and returns a meta object containing the children seperated by these
  # keys. If the piped element is a scalar or array, this does not look
  # at the children, but just returns that element in the meta object.
  if categorize == "scalar" then { objects: [], arrays: [], scalars: [.] }
  elif categorize == "array" then { objects: [], arrays: [.], scalars: [] }
  else { objects: [pluck("object")], arrays : [pluck("array")], scalars: [pluck("scalar")] }
  end;

def unwrap:
  # Unwraps an array recursively, until the elements of the returned array
  # are either scalars or objects but not arrays. If piped element is not
  # an array, returns the element as is.
  if type != "array" then .
  elif length == 0  then empty
  else .[] | unwrap
  end;

def extract($category):
  # Extracts the elements of a particular category from the piped in array.
  # If the piped in element is not an array, this fn acts as filter to
  # only return the element if it is of the desired category.
  unwrap | select(.| categorize == $category);

def unroll:
  # Unrolls the passed in object recursively until only scalars are left.
  # Returns a row for each leaf node of tree structure of the object and
  # elements of the row would be all the scalars encountered at all the
  # ancestor levels of this left node.
  . | .result += .state.scalars
    | .state.objects += [.state.arrays | extract("object")]
    | .state.objects += [.state.arrays | extract("scalar")]
    | if (.state.objects | length == 0 )
      then .result
      else ({ data : .state.objects,
              state: .state.objects[] | split,
              result: .result
            } | unroll)
      end;

def unrolls($data): { data: $data, state: $data| split, result: [] } | unroll ;
def unrolls: unrolls(.);

# source: _general/codepoints.md 

def smart_squotes($s):
  $s | if (test("[\\s\\n\\t]";"x")) then "\([39]|implode)\($s)\([39]|implode)" else $s end;

def smart_dquotes($s):
  $s | if (test("[\\s\\n\\t]";"x")) then "\($s|@json)" else $s end;

# source: _general/reduce.md 

def tocsv:
  .[0] as $cols | .[1:]
  | map(. as $row
  | $cols
  | with_entries({ "key": .value,"value": $row[.key]})
  );

# source: _general/wrangle.md 

def s: [splits(" +")];

