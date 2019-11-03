# Postcode Checker

An app to check if an inputted postcode is whitelisted or falls under an allowed LSOA area, using the postcodes.io API.


## Getting started
Clone the repo and run setup - this will install dependencies with bundler, and create the databases:
```
$ git clone git@github.com:rebeccasedgwick/postcode_checker.git
$ cd postcode_checker
$ bin/setup
```
Run the server:
```
$ bundle exec rails s
```
The app will then be running at http://localhost:3000

## Testing
Tests have been written with RSpec and can be found in the `spec` directory.  
To run tests (optional `-fd` for verbose output):
```
$ bundle exec rspec
```


## Notes
The postcode whitelist is seeded with two postcodes, 'SH24 1AA' and 'SH24 1AB'.  
Any postcode that falls under a LSOA starting 'Southwark' or 'Lambeth' is allowed.
