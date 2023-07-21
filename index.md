---
layout: default
title: Home
nav_exclude: true
---

[View the wiki](https://github.com/nntrn/jq-recipes/wiki)

## Setup

[**Download recipes.jq**](https://nntrn.github.io/jq-recipes/recipes.jq)

```console
$ mkdir -p ~/.jq
$ curl --output-dir ~/.jq https://nntrn.github.io/jq-recipes/jqrecipes.jq
```

## Usage

```sh
jq 'include "recipes"; <funcname>' <jsonfile>
```


<details open=false>
<pre>{% include_relative jqrecipes.jq %}</pre>
</details>
