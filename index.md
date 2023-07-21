---
layout: default
title: Home
nav_exclude: true
---

[View the wiki](https://github.com/nntrn/jq-recipes/wiki)

## Setup

[**Download recipes.jq**](https://nntrn.github.io/jq-recipes/recipes.jq)

```console
$ mkdir -p ~/.jq && cd $_
$ curl -O https://nntrn.github.io/jq-recipes/recipes.jq
```

## Usage

```sh
jq 'include "recipes"; <funcname>' <jsonfile>
```

<details>
<pre>{% include_relative recipes.jq %}</pre>
</details>
