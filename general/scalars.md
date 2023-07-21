# Scalars

{: .data }

> ```sh
> curl -o events.json 'https://api.github.com/users/nntrn/events/public?per_page=3'
> ```

## Flatten

```sh
jq '. as $data | [path(..| select(scalars))] | map({ (.|join(".")): (. as $path | .=$data | getpath($path)) }) | add' events.json
```

<details><summary>Output</summary>
<pre>{
  "0.id": "30296500963",
  "0.type": "WatchEvent",
  "0.actor.id": 17685332,
  "0.actor.login": "nntrn",
  "0.actor.display_login": "nntrn",
  "0.actor.gravatar_id": "",
  "0.actor.url": "https://api.github.com/users/nntrn",
  "0.actor.avatar_url": "https://avatars.githubusercontent.com/u/17685332?",
  "0.repo.id": 58597275,
  "0.repo.name": "rbarton65/espnff",
  "0.repo.url": "https://api.github.com/repos/rbarton65/espnff",
  "0.payload.action": "started",
  "0.public": true,
  "0.created_at": "2023-07-09T22:47:44Z",
  "1.id": "30291015875",
  "1.type": "WatchEvent",
  "1.actor.id": 17685332,
  "1.actor.login": "nntrn",
  "1.actor.display_login": "nntrn",
  "1.actor.gravatar_id": "",
  "1.actor.url": "https://api.github.com/users/nntrn",
  "1.actor.avatar_url": "https://avatars.githubusercontent.com/u/17685332?",
  "1.repo.id": 295774370,
  "1.repo.name": "mdn/content",
  "1.repo.url": "https://api.github.com/repos/mdn/content",
  "1.payload.action": "started",
  "1.public": true,
  "1.created_at": "2023-07-09T09:29:27Z",
  "1.org.id": 7565578,
  "1.org.login": "mdn",
  "1.org.gravatar_id": "",
  "1.org.url": "https://api.github.com/orgs/mdn",
  "1.org.avatar_url": "https://avatars.githubusercontent.com/u/7565578?",
  "2.id": "30289290731",
  "2.type": "PushEvent",
  "2.actor.id": 17685332,
  "2.actor.login": "nntrn",
  "2.actor.display_login": "nntrn",
  "2.actor.gravatar_id": "",
  "2.actor.url": "https://api.github.com/users/nntrn",
  "2.actor.avatar_url": "https://avatars.githubusercontent.com/u/17685332?",
  "2.repo.id": 582752600,
  "2.repo.name": "nntrn/jq-recipes",
  "2.repo.url": "https://api.github.com/repos/nntrn/jq-recipes",
  "2.payload.repository_id": 582752600,
  "2.payload.push_id": 14253402957,
  "2.payload.size": 1,
  "2.payload.distinct_size": 1,
  "2.payload.ref": "refs/heads/devel",
  "2.payload.head": "937e0ead5286f02581c05bc866730c1621f29e19",
  "2.payload.before": "218054bd5f7e02956ca0be5448fd652d3891f229",
  "2.payload.commits.0.sha": "937e0ead5286f02581c05bc866730c1621f29e19",
  "2.payload.commits.0.author.email": "17685332+nntrn@users.noreply.github.com",
  "2.payload.commits.0.author.name": "nntrn",
  "2.payload.commits.0.message": "Update search result style",
  "2.payload.commits.0.distinct": true,
  "2.payload.commits.0.url": "https://api.github.com/repos/nntrn/jq-recipes/commits/937e0ead5286f02581c05bc866730c1621f29e19",
  "2.public": true,
  "2.created_at": "2023-07-09T04:15:24Z"
}</pre>
</details>

## Target URLs

Select paths that begin with `https://`

```sh
jq '. as $data | [path(..| select(scalars and (tostring | test("^https://";"x"))))] | map({ (.|join(".")): (. as $path | .=$data | getpath($path)) })|add' events.json
```

<details><summary>Output</summary>
<pre>{
  "0.actor.url": "https://api.github.com/users/nntrn",
  "0.actor.avatar_url": "https://avatars.githubusercontent.com/u/17685332?",
  "0.repo.url": "https://api.github.com/repos/rbarton65/espnff",
  "1.actor.url": "https://api.github.com/users/nntrn",
  "1.actor.avatar_url": "https://avatars.githubusercontent.com/u/17685332?",
  "1.repo.url": "https://api.github.com/repos/mdn/content",
  "1.org.url": "https://api.github.com/orgs/mdn",
  "1.org.avatar_url": "https://avatars.githubusercontent.com/u/7565578?",
  "2.actor.url": "https://api.github.com/users/nntrn",
  "2.actor.avatar_url": "https://avatars.githubusercontent.com/u/17685332?",
  "2.repo.url": "https://api.github.com/repos/nntrn/jq-recipes",
  "2.payload.commits.0.url": "https://api.github.com/repos/nntrn/jq-recipes/commits/937e0ead5286f02581c05bc866730c1621f29e19"
}</pre>
</details>

---

### Breakdown

Adapted from [5 Useful jq Commands to Parse JSON on the CLI](https://www.fabian-keller.de/blog/5-useful-jq-commands-parse-json-cli/):

- first store a reference to the complete data set - we'll need this later

  ```sh
  jq '. as $data | .' events.json
  ```

- now with `..` traverse the whole tree applying the path() function to retrieve the location

  ```sh
  jq '. as $data | [path(..)]' events.json
  ```

- we want to select only paths that are scalars (i.e. leaf nodes) and that match the regexp "merge"

  ```sh
  jq '. as $data | [path(..| select(scalars and (tostring | test("merge", "ixn")))) ]' events.json
  ```

- now that we have all the paths with matches, lets map them to an object with the key being a string representation of the key

  ```sh
  jq '. as $data | [path(..| select(scalars and (tostring | test("merge", "ixn")))) ] | map({ (.|join(".")): "static" })' events.json
  ```

- using the `getpath` function we can pop in the original value at the path (i.e. the scalar containing the match)

  ```sh
  jq '. as $data | [path(..| select(scalars and (tostring | test("merge", "ixn")))) ] | map({ (.|join(".")): (. as $path | .=$data | getpath($path)) })' events.json
  ```

- finally `reduce` all key-value matches to a single object

  ```sh
  jq '. as $data | [path(..| select(scalars and (tostring | test("merge", "ixn")))) ] | map({ (.|join(".")): (. as $path | .=$data | getpath($path)) }) | reduce .[] as $item ({}; . * $item)' events.json
  ```
