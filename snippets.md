# snippets

**Create object with filename as key and content as value:**

```sh
jq 'reduce inputs as $s (.; .[input_filename|gsub(".json";"")|split("/")|last] += $s)' ./*.json
```

```sh
jq --arg key value 'group_by(.[$key]) | map({"\(.[0][$key])": length}) | add'
```

<details><summary>Example</summary>

```console
$ jq --arg key Status 'group_by(.[$key]) | map({"\(.[0][$key])": length}) | add'
{
  "Disabled": 35,
  "Ready": 191,
  "Running": 2,
  "Status": 99
}  
```
  
</details>
