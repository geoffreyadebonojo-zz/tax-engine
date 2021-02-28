# README

### Endpoints
##### USERS
###### To get data on existing user

`GET /user/uuid=9b44abb039da2fec8bbb`
```
{
    "user": {
        "id": 1,
        "uuid": "9b44abb039da2fec8bbb",
        "tax_brackets": [
            {
                "lowest_amount": 50000,
                "percentage": 0.3
            },
            {
                "lowest_amount": 20000,
                "percentage": 0.2
            },
            {
                "lowest_amount": 10000,
                "percentage": 0.1
            },
            {
                "lowest_amount": 0,
                "percentage": 0.0
            }
        ],
        "created_at": "2021-02-28T21:57:29.000Z",
        "updated_at": "2021-02-28T21:57:29.000Z"
    }
}
```

###### To create a new user with a random uuid

`POST /user/new`
```
{
    "user": {
        "id": 2,
        "uuid": "b0c27795c8e44cd51932",
        "tax_brackets": [],
        "created_at": "2021-02-28T22:01:19.000Z",
        "updated_at": "2021-02-28T22:01:19.000Z"
    },
    "message": "You have successfully created a user."
}
```

#### TAX BRACKETS
##### To retrieve tax brackets for a user

`GET /tax_brackets?uuid=9b44abb039da2fec8bbb`
```
{
    "tax_brackets": [
        {
            "lowest_amount": 77770,
            "percentage": 0.59
        },
        {
            "lowest_amount": 500,
            "percentage": 0.4
        },
        {
            "lowest_amount": 0,
            "percentage": 0.0
        }
    ]
}
```

##### To create a new tax bracket for a user
Specify the `lowest_amount` and the `percentage`. New tax bracket displayed in response. You won't be able to create new brackets that have the same value as existing brackets.

`POST /tax_bracket/new?uuid=9b44abb039da2fec8bbb&lowest_amount=500&percentage=4`
```
{
    "newest_bracket": {
        "lowest_amount": 500,
        "percentage": 0.04
    },
    "user": {
        "tax_brackets": [
            {
                "lowest_amount": 50000,
                "percentage": 0.3
            },
            {
                "lowest_amount": 20000,
                "percentage": 0.2
            },
            {
                "lowest_amount": 10000,
                "percentage": 0.1
            },
            {
                "lowest_amount": 500,
                "percentage": 0.04
            },
            {
                "lowest_amount": 0,
                "percentage": 0.0
            }
        ],
        "id": 1,
        "uuid": "9b44abb039da2fec8bbb",
        "created_at": "2021-02-28T21:57:29.000Z",
        "updated_at": "2021-02-28T22:04:48.000Z"
    }
}
```

##### To change an existing tax bracket
Uses the index value of the tax bracket to update `lowest_amount` and tax `percentage`

`POST /tax_bracket/update?uuid=9b44abb039da2fec8bbb&lowest_amount=30000&percentage=40&bracket_id=0`
```
{
    "newest_bracket": {
        "lowest_amount": 50000,
        "percentage": 0.4
    },
    "existing_tax_brackets": [
        {
            "lowest_amount": 50000,
            "percentage": 0.4,
            "id": 0
        },
        {
            "lowest_amount": 20000,
            "percentage": 0.2,
            "id": 1
        },
        {
            "lowest_amount": 10000,
            "percentage": 0.1,
            "id": 2
        },
        {
            "lowest_amount": 0,
            "percentage": 0.0,
            "id": 3
        }
    ]
}
```

#### TAX INCOME
##### Calculate taxable income based on tax brackets for a user based on income
Requires an `amount`. Won't accept words, or any number below 1.

`GET /taxable_income?uuid=9b44abb039da2fec8bbb&amount=50000`
```
{
    "tax_owed": 7000.0,
    "uuid": "9b44abb039da2fec8bbb"
}
```
