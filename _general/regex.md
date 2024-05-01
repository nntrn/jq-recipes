---
title: regex
---
jq uses the Oniguruma regular expression library

| Match               |  |
|---------------------|-------|
| Positive lookahead  | ?=    |
| Negative lookahead  | ?!    |
| Positive lookbehind | ?<=   |
| Negative lookbehind | ?<!   |


```
Extended groups

  i: ignore case
  m: multi-line (dot (.) also matches newline)
  x: extended form
  W: ASCII only word (\w, \p{Word}, [[:word:]])
     ASCII only word bound (\b)
  D: ASCII only digit (\d, \p{Digit}, [[:digit:]])
  S: ASCII only space (\s, \p{Space}, [[:space:]])
  P: ASCII only POSIX properties (includes W,D,S)
      (alnum, alpha, blank, cntrl, digit, graph,
      lower, print, punct, space, upper, xdigit, word)

  y{?}: Text Segment mode
    This option changes the meaning of \X, \y, \Y.
    Currently, this option is supported in Unicode only.

    y{g}: Extended Grapheme Cluster mode (default)
    y{w}: Word mode
```                              
                              
## Lookahead

Remove repeating characters

```console
$ jq -n '"aaaabbbbcccc" | gsub("(.)(?=.*\\1)";"")'
"abc"

$ jq -n '"aaaabbbbccccaaaa" | gsub("(.)(?=.*\\1)";"")'
"bca"
```

Only remove first repeating 'a'

```console
$ jq -n '"aaaabbbbcccc126186" | gsub("\\b(.)(?=.*\\1)";"")'
"abbbbcccc126186"
```

```console
$ jq -n '"aaaa bbbb cccc 126 126" | gsub("(\\b.)(?=.*\\1)";"")'
"abc 126"
```

### Resources: 

* [Regex remove repeated characters from a string](https://stackoverflow.com/a/19301868)
* [Oniguruma Regular Expressions](https://github.com/kkos/oniguruma/blob/master/doc/RE)

 