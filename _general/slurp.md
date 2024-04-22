---
---
# Slurp

## Slurpfile

```console
$ jq --slurpfile cars data/cars.json '{titanic: .[0:1], cars: $cars[][0:1]}' data/titanic.json
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
    }
  ]
}
```