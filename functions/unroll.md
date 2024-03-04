# Unroll

```jq
[leaf_paths as $path | {
  "key": $path | map(tostring) | join("_"),
  "value": getpath($path)
}] | from_entries
```

```console
$ cat data/nested.json|jq '[leaf_paths as $path | {
  "key": $path | map(tostring) | join("_"),
  "value": getpath($path)
}] | from_entries
'
{
  "server_atx_user": "annie",
  "server_atx_port": 22,
  "storage_nyc_user": "nntrn",
  "storage_nyc_port": 22
}
```

```jq
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
```
