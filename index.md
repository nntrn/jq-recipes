---
layout: minimal
title: Home
nav_exclude: true
---

## Setup

Download [recipes.jq](https://nntrn.github.io/jq-recipes/recipes.jq)

```console
$ curl --create-dirs -o ~/.jq/recipes.jq https://nntrn.github.io/jq-recipes/recipes.jq
```

## Usage

```sh
jq 'include "recipes"; <funcname>' <jsonfile>
```

<details><summary>View contents</summary>
<pre>{% include_relative recipes.jq %}</pre>
</details>
