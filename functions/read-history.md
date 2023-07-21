# Read history

Compile timestamps in `.bash_history` for all users

```jq
def history:
  map(
    if test("#[0-9]{10,12}")
    then "\(.|gsub("#";"")|tonumber|todate)"
    else "\t\(.)\n"
    end
  ) | join("");
```

Requires root privileges

```sh
head -n 100 /home/*/.bash_history |
  jq -Rs -r 'include "jqrecipes"; split("\n") | history'
```

Output:

```
        ==> /home/svc_prddbaasawx/.bash_history <==
2022-05-20 17:25:28     cat .git/config
2022-05-27 02:35:56     git --help all

        ==> /home/admdarrell/.bash_history <==
2022-02-27T07:32:57Z    sudo su -
2022-02-27T07:33:21Z    exit
2022-02-27T07:35:24Z    sudo su -

        ==> /home/annie_tran/.bash_history <==
2021-03-31 11:50:20     sudo su -
2021-03-31 11:51:25     clear
2021-03-31 11:51:27     pstree
```

Before:

```sh
#1617209420
sudo su -
#1617209485
clear
#1617209487
pstree
```
