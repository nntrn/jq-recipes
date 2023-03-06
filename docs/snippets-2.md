# Snippets (from man page)

Examples taken from jq's man page

```sh
echo '"Hello, world!"' |
  jq -c '.'

			# "Hello, world!"

echo '{"foo": 42, "bar": "less interesting data"}' |
  jq -c '.foo'

			# 42

echo '{"notfoo": true, "alsonotfoo": false}' |
  jq -c '.foo'

			# null

echo '{"foo": 42}' |
  jq -c '.["foo"]'

			# 42

echo '{"foo": 42, "bar": "less interesting data"}' |
  jq -c '.foo?'

			# 42

echo '{"notfoo": true, "alsonotfoo": false}' |
  jq -c '.foo?'

			# null

echo '{"foo": 42}' |
  jq -c '.["foo"]?'

			# 42

echo '[1,2]' |
  jq -c '[.foo?]'

			# []

echo '[{"name":"JSON", "good":true}, {"name":"XML", "good":false}]' |
  jq -c '.[0]'

			# {"name":"JSON","good":true}

echo '[{"name":"JSON", "good":true}, {"name":"XML", "good":false}]' |
  jq -c '.[2]'

			# null

echo '[1,2,3]' |
  jq -c '.[-2]'

			# 2

echo '[1,2,5,3,5,3,1,3]' |
  jq -c 'unique'

			# [1,2,3,5]

echo '[{"foo": 1, "bar": 2}, {"foo": 1, "bar": 3}, {"foo": 4, "bar": 5}]' |
  jq -c 'unique_by(.foo)'

			# [{"foo":1,"bar":2},{"foo":4,"bar":5}]

echo '["chunky", "bacon", "kitten", "cicada", "asparagus"]' |
  jq -c 'unique_by(length)'

			# ["bacon","chunky","asparagus"]

echo '[1,2,3,4]' |
  jq -c 'reverse'

			# [4,3,2,1]

echo '"foobar"' |
  jq -c 'contains("bar")'

			# true

echo '["foobar", "foobaz", "blarp"]' |
  jq -c 'contains(["baz", "bar"])'

			# true

echo '["foobar", "foobaz", "blarp"]' |
  jq -c 'contains(["bazzzzz", "bar"])'

			# false

echo '{"foo": 12, "bar":[1,2,{"barp":12, "blip":13}]}' |
  jq -c 'contains({foo: 12, bar: [{barp: 12}]})'

			# true

echo '{"foo": 12, "bar":[1,2,{"barp":12, "blip":13}]}' |
  jq -c 'contains({foo: 12, bar: [{barp: 15}]})'

			# false

echo '"a,b, cd, efg, hijk"' |
  jq -c 'indices(", ")'

			# [3,7,12]

echo '["a","b","c","d","e"]' |
  jq -c '.[2:4]'

			# ["c","d"]

echo '[0,1,2,1,3,1,4]' |
  jq -c 'indices(1)'

			# [1,3,5]

echo '[0,1,2,3,1,4,2,5,1,2,6,7]' |
  jq -c 'indices([1,2])'

			# [1,8]

echo '"a,b, cd, efg, hijk"' |
  jq -c 'index(", ")'

			# 3

echo '"a,b, cd, efg, hijk"' |
  jq -c 'rindex(", ")'

			# 12

echo '"bar"' |
  jq -c 'inside("foobar")'

			# true

echo '["baz", "bar"]' |
  jq -c 'inside(["foobar", "foobaz", "blarp"])'

			# true

echo '["bazzzzz", "bar"]' |
  jq -c 'inside(["foobar", "foobaz", "blarp"])'

			# false

echo '{"foo": 12, "bar": [{"barp": 12}]}' |
  jq -c 'inside({"foo": 12, "bar":[1,2,{"barp":12, "blip":13}]})'

			# true

echo '{"foo": 12, "bar": [{"barp": 15}]}' |
  jq -c 'inside({"foo": 12, "bar":[1,2,{"barp":12, "blip":13}]})'

			# false

echo '["fo", "foo", "barfoo", "foobar", "barfoob"]' |
  jq -c '[.[]|startswith("foo")]'

			# [false,true,false,true,false]

echo '"abcdefghi"' |
  jq -c '.[2:4]'

			# "cd"

echo '["foobar", "barfoo"]' |
  jq -c '[.[]|endswith("foo")]'

			# [false,true]

echo '[[1,2], [3, 4]]' |
  jq -c 'combinations'

			# [1,3]
			# [1,4]
			# [2,3]
			# [2,4]

echo '[0, 1]' |
  jq -c 'combinations(2)'

			# [0,0]
			# [0,1]
			# [1,0]
			# [1,1]

echo '["fo", "foo", "barfoo", "foobar", "afoo"]' |
  jq -c '[.[]|ltrimstr("foo")]'

			# ["fo","","barfoo","bar","afoo"]

echo '["fo", "foo", "barfoo", "foobar", "foob"]' |
  jq -c '[.[]|rtrimstr("foo")]'

			# ["fo","","bar","foobar","foob"]

echo '"foobar"' |
  jq -c 'explode'

			# [102,111,111,98,97,114]

echo '[65, 66, 67]' |
  jq -c 'implode'

			# "ABC"

echo '"a, b,c,d, e, "' |
  jq -c 'split(", ")'

			# ["a","b,c,d","e",""]

echo '["a","b,c,d","e"]' |
  jq -c 'join(", ")'

			# "a, b,c,d, e"

echo '["a",1,2.3,true,null,false]' |
  jq -c 'join(" ")'

			# "a 1 2.3 true  false"

echo '["a","b","c","d","e"]' |
  jq -c '.[:3]'

			# ["a","b","c"]

echo '1' |
  jq -c '[while(.<100; .*2)]'

			# [1,2,4,8,16,32,64]

echo '4' |
  jq -c '[.,1]|until(.[0] < 1; [.[0] - 1, .[1] * .[0]])|.[1]'

			# 24

echo '{"foo":[{"foo": []}, {"foo":[{"foo":[]}]}]}' |
  jq -c 'recurse(.foo[])'

			# {"foo":[{"foo":[]},{"foo":[{"foo":[]}]}]}
			# {"foo":[]}
			# {"foo":[{"foo":[]}]}
			# {"foo":[]}

echo '{"a":0,"b":[1]}' |
  jq -c 'recurse'

			# {"a":0,"b":[1]}
			# 0
			# [1]
			# 1

echo '2' |
  jq -c 'recurse(. * .; . < 20)'

			# 2
			# 4
			# 16

echo '[[4, 1, 7], [8, 5, 2], [3, 6, 9]]' |
  jq -c 'walk(if type == "array" then sort else . end)'

			# [[1,4,7],[2,5,8],[3,6,9]]

echo '[ { "_a": { "__b": 2 } } ]' |
  jq -c 'walk( if type == "object" then with_entries( .key |= sub( "^_+"; "") ) else . end )'

			# [{"a":{"b":2}}]

echo 'null' |
  jq -c '$ENV.PAGER'

			# null

echo 'null' |
  jq -c 'env.PAGER'

			# null

echo '[[1], [2,3]]' |
  jq -c 'transpose'

			# [[1,2],[null,3]]

echo '["a","b","c","d","e"]' |
  jq -c '.[-2:]'

			# ["d","e"]

echo '[0,1]' |
  jq -c 'bsearch(0)'

			# 0

echo '[1,2,3]' |
  jq -c 'bsearch(0)'

			# -1

echo '[1,2,3]' |
  jq -c 'bsearch(4) as $ix | if $ix < 0 then .[-(1+$ix)] = 4 else . end'

			# [1,2,3,4]

echo '42' |
  jq -c '"The input was \(.), which is one less than \(.+1)"'

			# "The input was 42, which is one less than 43"

echo '[1, "foo", ["foo"]]' |
  jq -c '[.[]|tostring]'

			# ["1","foo","[\"foo\"]"]

echo '[1, "foo", ["foo"]]' |
  jq -c '[.[]|tojson]'

			# ["1","\"foo\"","[\"foo\"]"]

echo '[1, "foo", ["foo"]]' |
  jq -c '[.[]|tojson|fromjson]'

			# [1,"foo",["foo"]]

echo '"This works if x < y"' |
  jq -c '@html'

			# "This works if x &lt; y"

echo '"O"Hara"s Ale"' |
  jq -c '@sh "echo \(.)"'

			# "echo 'O'"

echo '"This is a message"' |
  jq -c '@base64'

			# "VGhpcyBpcyBhIG1lc3NhZ2U="

echo '[{"name":"JSON", "good":true}, {"name":"XML", "good":false}]' |
  jq -c '.[]'

			# {"name":"JSON","good":true}
			# {"name":"XML","good":false}

echo '"VGhpcyBpcyBhIG1lc3NhZ2U="' |
  jq -c '@base64d'

			# "This is a message"

echo '"2015-03-05T23:51:47Z"' |
  jq -c 'fromdate'

			# 1425599507

echo '"2015-03-05T23:51:47Z"' |
  jq -c 'strptime("%Y-%m-%dT%H:%M:%SZ")'

			# [2015,2,5,23,51,47,4,63]

echo '"2015-03-05T23:51:47Z"' |
  jq -c 'strptime("%Y-%m-%dT%H:%M:%SZ")|mktime'

			# 1425599507

echo '[1, 1.0, "1", "banana"]' |
  jq -c '.[] == 1'

			# true
			# true
			# false
			# false

echo '2' |
  jq -c '. < 5'

			# true

echo 'null' |
  jq -c '42 and "a string"'

			# true

echo 'null' |
  jq -c '(true, false) or false'

			# true
			# false

echo 'null' |
  jq -c '(true, true) and (true, false)'

			# true
			# false
			# true
			# false

echo 'null' |
  jq -c '[true, false | not]'

			# [false,true]

echo '[]' |
  jq -c '.[]'

echo '{"foo": 19}' |
  jq -c '.foo // 42'

			# 19

echo '{}' |
  jq -c '.foo // 42'

			# 42

echo 'true' |
  jq -c 'try .a catch ". is not an object"'

			# ". is not an object"

echo '[{}, true, {"a":1}]' |
  jq -c '[.[]|try .a]'

			# [null,1]

echo 'true' |
  jq -c 'try error("some exception") catch .'

			# "some exception"

echo '[{}, true, {"a":1}]' |
  jq -c '[.[]|(.a)?]'

			# [null,1]

echo '"foo"' |
  jq -c 'test("foo")'

			# true

echo '["xabcd", "ABC"]' |
  jq -c '.[] | test("a b c # spaces are ignored"; "ix")'

			# true
			# true

echo '"abc abc"' |
  jq -c 'match("(abc)+"; "g")'

			# {"offset":0,"length":3,"string":"abc","captures":[{"offset":0,"length":3,"string":"abc","name":null}]}
			# {"offset":4,"length":3,"string":"abc","captures":[{"offset":4,"length":3,"string":"abc","name":null}]}

echo '"foo bar foo"' |
  jq -c 'match("foo")'

			# {"offset":0,"length":3,"string":"foo","captures":[]}

echo '{"a": 1, "b": 1}' |
  jq -c '.[]'

			# 1
			# 1

echo '"foo bar FOO"' |
  jq -c 'match(["foo", "ig"])'

			# {"offset":0,"length":3,"string":"foo","captures":[]}
			# {"offset":8,"length":3,"string":"FOO","captures":[]}

echo '"foo bar foo foo  foo"' |
  jq -c 'match("foo (?<bar123>bar)? foo"; "ig")'

			# {"offset":0,"length":11,"string":"foo bar foo","captures":[{"offset":4,"length":3,"string":"bar","name":"bar123"}]}
			# {"offset":12,"length":8,"string":"foo  foo","captures":[{"offset":-1,"string":null,"length":0,"name":"bar123"}]}

echo '"abc"' |
  jq -c '[ match("."; "g")] | length'

			# 3

echo '"xyzzy-14"' |
  jq -c 'capture("(?<a>[a-z]+)-(?<n>[0-9]+)")'

			# {"a":"xyzzy","n":"14"}

echo '{"foo":10, "bar":200}' |
  jq -c '.bar as $x | .foo | . + $x'

			# 210

echo '5' |
  jq -c '. as $i|[(.*2|. as $i| $i), $i]'

			# [10,5]

echo '[2, 3, {"c": 4, "d": 5}]' |
  jq -c '. as [$a, $b, {c: $c}] | $a + $b + $c'

			# 9

echo '[[0], [0, 1], [2, 1, 0]]' |
  jq -c '.[] as [$a, $b] | {a: $a, b: $b}'

			# {"a":0,"b":null}
			# {"a":0,"b":1}
			# {"a":2,"b":1}

echo '[[1,2],[10,20]]' |
  jq -c 'def addvalue(f): . + [f]; map(addvalue(.[0]))'

			# [[1,2,1],[10,20,10]]

echo '[[1,2],[10,20]]' |
  jq -c 'def addvalue(f): f as $x | map(. + $x); addvalue(.[0])'

			# [[1,2,1,2],[10,20,1,2]]

echo '{"foo": 42, "bar": "something else", "baz": true}' |
  jq -c '.foo, .bar'

			# 42
			# "something else"

echo '[10,2,5,3]' |
  jq -c 'reduce .[] as $item (0; . + $item)'

			# 20

echo 'null' |
  jq -c 'isempty(empty)'

			# true

echo '[0,1,2,3,4,5,6,7,8,9]' |
  jq -c '[limit(3;.[])]'

			# [0,1,2]

echo '10' |
  jq -c '[first(range(.)), last(range(.)), nth(./2; range(.))]'

			# [0,9,5]

echo '10' |
  jq -c '[range(.)]|[first, last, nth(5)]'

			# [0,9,5]

echo '[1,2,3,4,null,"a","b",null]' |
  jq -c '[foreach .[] as $item ([[],[]]; if $item == null then [[],.[0]] else [(.[0] + [$item]),[]] end; if $item == null then .[1] else empty end)]'

			# [[1,2,3,4],["a","b"]]

echo 'null' |
  jq -c 'def range(init; upto; by): def _range: if (by > 0 and . < upto) or (by < 0 and . > upto) then ., ((.+by)|_range) else . end; if by == 0 then init else init|_range end | select((by > 0 and . < upto) or (by < 0 and . > upto)); range(0; 10; 3)'

			# 0
			# 3
			# 6
			# 9

echo '1' |
  jq -c 'def while(cond; update): def _while: if cond then ., (update | _while) else empty end; _while; [while(.<100; .*2)]'

			# [1,2,4,8,16,32,64]

echo '1' |
  jq -c '[1|truncate_stream([[0],1],[[1,0],2],[[1,0]],[[1]])]'

			# [[[0],2],[[0]]]

echo 'null' |
  jq -c 'fromstream(1|truncate_stream([[0],1],[[1,0],2],[[1,0]],[[1]]))'

			# [2]

echo '{"user":"stedolan", "projects": ["jq", "wikiflow"]}' |
  jq -c '.user, .projects[]'

			# "stedolan"
			# "jq"
			# "wikiflow"

echo '[0,[1,{"a":1},{"b":2}]]' |
  jq -c '. as $dot|fromstream($dot|tostream)|.==$dot'

			# true

echo '[true,false,[5,true,[true,[false]],false]]' |
  jq -c '(..|select(type=="boolean")) |= if . then 1 else 0 end'

			# [1,0,[5,1,[1,[0]],0]]

echo '{"foo": 42}' |
  jq -c '.foo += 1'

			# {"foo":43}

echo '["a","b","c","d","e"]' |
  jq -c '.[4,2]'

			# "e"
			# "c"

echo '[{"name":"JSON", "good":true}, {"name":"XML", "good":false}]' |
  jq -c '.[] | .name'

			# "JSON"
			# "XML"

echo '1' |
  jq -c '(. + 2) * 5'

			# 15

echo '{"user":"stedolan", "projects": ["jq", "wikiflow"]}' |
  jq -c '[.user, .projects[]]'

			# ["stedolan","jq","wikiflow"]

echo '[1, 2, 3]' |
  jq -c '[ .[] | . * 2]'

			# [2,4,6]

echo '{"user":"stedolan","titles":["JQ Primer", "More JQ"]}' |
  jq -c '{user, title: .titles[]}'

			# {"user":"stedolan","title":"JQ Primer"}
			# {"user":"stedolan","title":"More JQ"}

echo '{"user":"stedolan","titles":["JQ Primer", "More JQ"]}' |
  jq -c '{(.user): .titles}'

			# {"stedolan":["JQ Primer","More JQ"]}

echo '[[{"a":1}]]' |
  jq -c '..|.a?'

			# 1

echo '{"a": 7}' |
  jq -c '.a + 1'

			# 8

echo '{"a": [1,2], "b": [3,4]}' |
  jq -c '.a + .b'

			# [1,2,3,4]

echo '{"a": 1}' |
  jq -c '.a + null'

			# 1

echo '{}' |
  jq -c '.a + 1'

			# 1

echo 'null' |
  jq -c '{a: 1} + {b: 2} + {c: 3} + {a: 42}'

			# {"a":42,"b":2,"c":3}

echo '{"a":3}' |
  jq -c '4 - .a'

			# 1

echo '["xml", "yaml", "json"]' |
  jq -c '. - ["xml", "yaml"]'

			# ["json"]

echo '5' |
  jq -c '10 / . * 3'

			# 6

echo '"a, b,c,d, e"' |
  jq -c '. / ", "'

			# ["a","b,c,d","e"]

echo 'null' |
  jq -c '{"k": {"a": 1, "b": 2}} * {"k": {"a": 0,"c": 3}}'

			# {"k":{"a":0,"b":2,"c":3}}

echo '[1,0,-1]' |
  jq -c '.[] | (1 / .)?'

			# 1
			# -1

echo '"\u03bc"' |
  jq -c 'utf8bytelength'

			# 2

echo '{"abc": 1, "abcd": 2, "Foo": 3}' |
  jq -c 'keys'

			# ["Foo","abc","abcd"]

echo '[42,3,35]' |
  jq -c 'keys'

			# [0,1,2]

echo '[{"foo": 42}, {}]' |
  jq -c 'map(has("foo"))'

			# [true,false]

echo '[[0,1], ["a","b","c"]]' |
  jq -c 'map(has(2))'

			# [false,true]

echo '["foo", "bar"]' |
  jq -c '.[] | in({"foo": 42})'

			# true
			# false

echo '[2, 0]' |
  jq -c 'map(in([0,1]))'

			# [false,true]

echo '[1,2,3]' |
  jq -c 'map(.+1)'

			# [2,3,4]

echo '{"a": 1, "b": 2, "c": 3}' |
  jq -c 'map_values(.+1)'

			# {"a":2,"b":3,"c":4}

echo 'null' |
  jq -c 'path(.a[0].b)'

			# ["a",0,"b"]

echo '{"a":[{"b":1}]}' |
  jq -c '[path(..)]'

			# [[],["a"],["a",0],["a",0,"b"]]

echo '{"foo": 42, "bar": 9001, "baz": 42}' |
  jq -c 'del(.foo)'

			# {"bar":9001,"baz":42}

echo '["foo", "bar", "baz"]' |
  jq -c 'del(.[1, 2])'

			# ["foo"]

echo 'null' |
  jq -c 'getpath(["a","b"])'

			# null

echo '{"a":{"b":0, "c":1}}' |
  jq -c '[getpath(["a","b"], ["a","c"])]'

			# [0,1]

echo 'null' |
  jq -c 'setpath(["a","b"]; 1)'

			# {"a":{"b":1}}

echo '{"a":{"b":0}}' |
  jq -c 'setpath(["a","b"]; 1)'

			# {"a":{"b":1}}

echo 'null' |
  jq -c 'setpath([0,"a"]; 1)'

			# [{"a":1}]

echo '{"a":{"b":1},"x":{"y":2}}' |
  jq -c 'delpaths([["a","b"]])'

			# {"a":{},"x":{"y":2}}

echo '{"a": 1, "b": 2}' |
  jq -c 'to_entries'

			# [{"key":"a","value":1},{"key":"b","value":2}]

echo '[{"key":"a", "value":1}, {"key":"b", "value":2}]' |
  jq -c 'from_entries'

			# {"a":1,"b":2}

echo '{"a": 1, "b": 2}' |
  jq -c 'with_entries(.key |= "KEY_" + .)'

			# {"KEY_a":1,"KEY_b":2}

echo '[1,5,3,0,7]' |
  jq -c 'map(select(. >= 2))'

			# [5,3,7]

echo '[{"id": "first", "val": 1}, {"id": "second", "val": 2}]' |
  jq -c '.[] | select(.id == "second")'

			# {"id":"second","val":2}

echo '[[],{},1,"foo",null,true,false]' |
  jq -c '.[]|numbers'

			# 1

echo 'null' |
  jq -c '1, empty, 2'

			# 1
			# 2

echo 'null' |
  jq -c '[1,2,empty,3]'

			# [1,2,3]

echo 'null' |
  jq -c 'try error("\($__loc__)") catch .'

			# "{\"file\":\"<top-level>\",\"line\":1}"

echo '[1,[[],{"a":2}]]' |
  jq -c '[paths]'

			# [[0],[1],[1,0],[1,1],[1,1,"a"]]

echo '[1,[[],{"a":2}]]' |
  jq -c '[paths(scalars)]'

			# [[0],[1,1,"a"]]

echo '["a","b","c"]' |
  jq -c 'add'

			# "abc"

echo '[1, 2, 3]' |
  jq -c 'add'

			# 6

echo '[]' |
  jq -c 'add'

			# null

echo '[true, false]' |
  jq -c 'any'

			# true

echo '[false, false]' |
  jq -c 'any'

			# false

echo '[]' |
  jq -c 'any'

			# false

echo '[true, false]' |
  jq -c 'all'

			# false

echo '[true, true]' |
  jq -c 'all'

			# true

echo '[]' |
  jq -c 'all'

			# true

echo '[1, [2], [[3]]]' |
  jq -c 'flatten'

			# [1,2,3]

echo '[1, [2], [[3]]]' |
  jq -c 'flatten(1)'

			# [1,2,[3]]

echo '[[]]' |
  jq -c 'flatten'

			# []

echo '[{"foo": "bar"}, [{"foo": "baz"}]]' |
  jq -c 'flatten'

			# [{"foo":"bar"},{"foo":"baz"}]

echo 'null' |
  jq -c 'range(2;4)'

			# 2
			# 3

echo 'null' |
  jq -c '[range(2;4)]'

			# [2,3]

echo 'null' |
  jq -c '[range(4)]'

			# [0,1,2,3]

echo 'null' |
  jq -c '[range(0;10;3)]'

			# [0,3,6,9]

echo 'null' |
  jq -c '[range(0;10;-1)]'

			# []

echo 'null' |
  jq -c '[range(0;-5;-1)]'

			# [0,-1,-2,-3,-4]

echo '3.14159' |
  jq -c 'floor'

			# 3

echo '9' |
  jq -c 'sqrt'

			# 3

echo '[1, "1"]' |
  jq -c '.[] | tonumber'

			# 1
			# 1

echo '[1, "1", [1]]' |
  jq -c '.[] | tostring'

			# "1"
			# "1"
			# "[1]"

echo '[0, false, [], {}, null, "hello"]' |
  jq -c 'map(type)'

			# ["number","boolean","array","object","null","string"]

echo '[-1, 1]' |
  jq -c '.[] | (infinite * .) < 0'

			# true
			# false

echo 'null' |
  jq -c 'infinite, nan | type'

			# "number"
			# "number"

echo '[8,3,null,6]' |
  jq -c 'sort'

			# [null,3,6,8]

echo '[{"foo":4, "bar":10}, {"foo":3, "bar":100}, {"foo":2, "bar":1}]' |
  jq -c 'sort_by(.foo)'

			# [{"foo":2,"bar":1},{"foo":3,"bar":100},{"foo":4,"bar":10}]

echo '[{"foo":1, "bar":10}, {"foo":3, "bar":100}, {"foo":1, "bar":1}]' |
  jq -c 'group_by(.foo)'

			# [[{"foo":1,"bar":10},{"foo":1,"bar":1}],[{"foo":3,"bar":100}]]

echo '[5,4,2,7]' |
  jq -c 'min'

			# 2

echo '[{"foo":1, "bar":14}, {"foo":2, "bar":3}]' |
  jq -c 'max_by(.foo)'

			# {"foo":2,"bar":3}

echo '[{"name":"JSON", "good":true}, {"name":"XML", "good":false}]' |
  jq -r '.[] | map(.) | @csv'

			# "JSON",true
			# "XML",false
```
