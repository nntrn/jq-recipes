---
title: kv
---

```jq
split("\n")
| map(
    select(. != "") |
    split("=") |
    {"key": .[0], "value": (.[1:] | join("="))}
  )
| from_entries
```

```console
$ env | jq -sR 'split("\n") | map(select(. != "") | split("=") | {"key": .[0], "value": (.[1:] | join("="))}) | from_entries'

{
  "XDG_SESSION_ID": "c18",
  "SHELL": "/bin/bash",
  "TERM": "xterm-256color",
  "HISTSIZE": "100000",
  "HISTFILESIZE": "10000000",
  "USER": "root",
  "MAIL": "/var/spool/mail/root",
  "PATH": "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/puppetlabs/bin:/usr/local/bin:/root/bin:/misc/software/database/engineering/bin",
  "PWD": "/root",
  "LANG": "en_US.UTF-8",
  "PS1": "\\[\\e]0;\\w\\a\\]\\n\\[\\e[32m\\]\\u@\\h \\[\\e[33m\\]\\w\\[\\e[0m\\]\\n$ ",
  "HISTIGNORE": "exit:^history*:clear",
  "HISTCONTROL": "ignoredups",
  "SHLVL": "1",
  "HOME": "/root",
  "LOGNAME": "root",
  "LESSOPEN": "||/usr/bin/lesspipe.sh %s",
  "_": "/bin/env"
}
```
