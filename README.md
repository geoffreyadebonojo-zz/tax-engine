# README

```
Ruby 2.7.1
Rails 5.2.4
```

#### Setup
```
git clone https://github.com/geoffreyadebonojo/tax-engine.git
cd tax-engine
bundle install
rake db:{create,migrate,seed}
```
#### Run tests
```
bundle exec rspec
```
and view coverage
```
open coverage/index.html
```

## ENDPOINTS
Start your local server with `rails server` and check out the following endpoints.

#### USERS
###### To create a new user with a random uuid

`POST /user/new`
```
{
  "user": {
    "id": 1,
    "uuid": "9b44abb039da2fec8bbb",
    "tax_brackets": [],
    "created_at": "2021-02-28T22:01:19.000Z",
    "updated_at": "2021-02-28T22:01:19.000Z"
  },
  "message": "You have successfully created a user."
}
```

###### To get data on existing user

`GET /user?uuid=9b44abb039da2fec8bbb`
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

#### TAX BRACKETS
##### To retrieve tax brackets for a user

`GET /tax_brackets?uuid=9b44abb039da2fec8bbb`
```
{
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
  ]
}
```

##### To create a new tax bracket for a user
Specify the `lowest_amount` and the `percentage`. The new tax bracket displayed in response. You won't be able to create a bracket with the same `lowest_amount` as one that already exists.

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
Use the index value of the tax bracket to update `lowest_amount` and tax `percentage`. You can't have more than one bracket with the same `lowest_amount`, so if you try to update a bracket and the new `lowest_amount` already exists on another bracket, you'll get an error.

`POST /tax_bracket/update?uuid=9b44abb039da2fec8bbb&lowest_amount=30000&percentage=40&bracket_id=0`
```
{
  "updated_bracket": {
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

##### To delete an existing tax bracket
Uses the index of the tax bracket to delete an existing bracket.

`DELETE /tax_bracket?bracket_id=0`
```
{
  "deleted_bracket": {
    "lowest_amount": 50000,
    "percentage": 0.3
  },
  "message": "Tax bracket successfully deleted",
  "user": {
    "tax_brackets": [
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
    "id": 1,
    "uuid": "9b44abb039da2fec8bbb",
    "created_at": "2021-02-28T22:21:52.000Z",
    "updated_at": "2021-02-28T22:22:44.000Z"
  }
}
```

#### TAX INCOME
##### Calculate taxable income based on tax brackets for a user based on income
Requires an `amount`, which is the income you want to calculate the tax on using the brackets for the user associated with that uuid. Won't accept words, or any number below 1.

`GET /taxable_income?uuid=9b44abb039da2fec8bbb&amount=50000`
```
{
  "tax_owed": 7000.0,
  "uuid": "9b44abb039da2fec8bbb"
}
```

# POINTS FOR DISCUSSION
##### Tax brackets as hashes in a column
If we have multiple millions of users, each with 50+ tax brackets, it seemed more efficient to use a hash as a column, seeing as how there's only the lowest_amount and percentage in the hash. I am genuinely curious about this, as a practice, regarding its actual speed/efficiency.

##### Using UUID instead of user namespace
This feels a bit unusual. Were the api offering more, I would probably refactor some of the endpoints under `/user`.

##### Inclusion of CSVs
I was thinking that whatever front-end makes use of this API could give users the option to upload a CSV with the tax brackets they intend to use. The CSV would be uploaded to an S3 bucket, which our API would then pull from to get the CSV data. Then we put that into our database. Just an added bit of flexibility.

##### Housekeeping and To Do list
- With more time I'd like the create sessions.
- Also the controllers are getting a little fat. The logic is getting slightly too involved. The TaxBracketController needs some cleanup and streamlining.
- Kinda mixing concerns, using the csv parser to feed TaxableIncome object in tests. Left it in partly so I don't have to keep writing those arrays, partly just as a reminder that it can do that.
- Fill out user model functionality with basic CRUD stuff and authentication. Right now it's set up like a public API where you request a key, and you get one. Should probably require an email address.
