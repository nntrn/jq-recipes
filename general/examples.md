# Examples

## Reduce

**Reduce Inputs**

```console
$ echo 1 2 3 | jq -cn 'reduce inputs as $i ([]; if $i==0 then empty else .+[$i] end)'
[1,2,3]

$ echo 1 2 3 0 | jq -cn 'reduce inputs as $i ([]; if $i==0 then empty else .+[$i] end)'
null
```

[Source](https://github.com/stedolan/jq/issues/873#issuecomment-125393055)

**Reduce sum**

```console
$ seq 5 | jq -n 'reduce inputs as $i (0;.+($i|tonumber))'
15
```

[Source](https://stackoverflow.com/a/74687036/7460613)

## Update-assignment: |=

```json
{
  "key1": {
    "attr1": "foo"
  },
  "key2": {
    "attr1": "foo",
    "attr2": "bar"
  }
}
```

```console
$ jq '.[] |= if .attr2 then (.attr2 = "bax") else . end'
{
  "key1": {
    "attr1": "foo"
  },
  "key2": {
    "attr1": "foo",
    "attr2": "bax"
  }
}
```

[[Source]](https://github.com/stedolan/jq/issues/873#issuecomment-125385615)


## Slurpfiles

```console
$ jq --slurpfile cars data/cars.json '{titanic: .[0:2],cars:$cars[][0:2]}' data/titanic.json
{
  "titanic": [
    {
      "Survived": 0,
      "Pclass": 3,
      "Name": "Mr. Owen Harris Braund",
      "Sex": "male",
      "Age": 22,
      "Siblings_Spouses_Aboard": 1,
      "Parents_Children_Aboard": 0,
      "Fare": 7.25
    },
    {
      "Survived": 1,
      "Pclass": 1,
      "Name": "Mrs. John Bradley (Florence Briggs Thayer) Cumings",
      "Sex": "female",
      "Age": 38,
      "Siblings_Spouses_Aboard": 1,
      "Parents_Children_Aboard": 0,
      "Fare": 71.2833
    }
  ],
  "cars": [
    {
      "name": "AMC Ambassador Brougham",
      "brand": "AMC",
      "economy_mpg_": 13,
      "cylinders": 8,
      "displacement_cc_": 360,
      "power_hp_": 175,
      "weight_lb_": 3821,
      "0_60_mph_s_": 11,
      "year": 1973
    },
    {
      "name": "AMC Ambassador DPL",
      "brand": "AMC",
      "economy_mpg_": 15,
      "cylinders": 8,
      "displacement_cc_": 390,
      "power_hp_": 190,
      "weight_lb_": 3850,
      "0_60_mph_s_": 8.5,
      "year": 1970
    }
  ]
}
```