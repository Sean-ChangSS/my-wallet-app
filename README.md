# Wellcome to my-wallet-app (a Crypto.com's Test)

Table of contents
1. [Environment Setup](#environment-setup)
2. [Feature Navigation](#feature-navigation)
3. [Project Navigation (How to view the code)](#project-navigation)
4. [Important Design Decisions](#important-design-decisions)
5. [Project Working Time](#project-working-time)
6. [Areas to Improve](#areas-to-improve)

## Environment Setup

1. Make sure docker is installed.
2. Run `docker-compose build` to build docker images.
3. Run `make db_create && make db_migrate` to create databse.
4. Run `make up` to launch rails service.
5. Run `curl -X GET http://localhost:3000/up` to check for service health.


## Feature Navigation

### Register User / Login To Get Jwt Token

All wallet operation must based on jwt token which is generated
from a registered user.
1. Register user with username `"test"`:
```curl -X POST http://localhost:3000/v1/user/sign_up -H "Content-Type: application/json" -d '{"username": "test"}'```
2. Get user token with username `"test"`:
```curl -X POST http://localhost:3000/v1/user/login -H "Content-Type: application/json" -d '{"username": "test"}'```
3. All the above APIs return token which should be used for wallet API.

### Wallet Feature

All the Wallet API should request with the following headers:
1. `Content-Type: application/json`
2. `Authorization: Bearer {your_user_token}`

The following example shows how to interact with API providing all the feature
required by the coding test. (The header mentioned above will be ignored for simplicity.)
1. Deposit money to user's wallet:
```curl -X POST http://localhost:3000/v1/wallet/deposit -d '{"amount": 10}'```
2. Withdraw money from user's wallet:
```curl -X POST http://localhost:3000/v1/wallet/withdraw -d '{"amount": 10}'```
3. Transfer money to another user (remember to register target username first):
```curl -X POST http://localhost:3000/v1/wallet/transfer -d '{"username": "test2", "amount": 10}'```
4. Get user's wallet balance:
```curl -X GET http://localhost:3000/v1/wallet/balance```
5. Get user's transaction history:
```curl -X GET http://localhost:3000/v1/wallet/transactions -d '{"page": 1, "per_page": 5}'```


## Project Navigation

- `config/routes.rb`: Defines API endpoints.
- `app/controllers/api_v1/*`: Entrypoints for API calls, some contains business logic.
- `app/services/*`: Business logic that changes DB.
- `app/models/*`: Defines active record with schema annotations.
- `spec/controllers/*`: Tests for all features (user, wallet).
- `lib/*`: Common utils.
- `db/migrate/*`: Database migration scripts.


## Important Design Decisions

### Implementing User System And Jwt Token

#### Initial Thoughts
I choose to implement user system and jwt token to simplify implementing wallet feature:
1. Wallet creation: The creation of wallet can be done right after user register.
2. Wallet API: To identify the user of request requires only authorization header instead of specifying it in payload.
3. Wallet Implementation: By adding identity check and user injection before controller action, the controller logic can get user without additional configuration.
The user system does not have password for simplicity consideration.

#### Follow Up Thoughts
I found out specifying wallet id in header can also inject wallet to execution context, which is simpler than using user + jwt. So this whole feature might be a bit over engineering...

### Choose Integer For Money Type

#### Initial Thoughts
Handling integer would be much simpler than decimals, so I choose to use integer has money type.

#### Follow up Thoughts
Using decimal as money type is more common for crypto coins. Maybe I should try it at first.

### Writing Test at API Level

#### Initial Thoughts
I didn't have a clear picture about how the architecture of my project will be, so I choose to write test at API level which will not be effect for most of architectural refactoring.

### Encapsulate Some of The Wallet Logic With Service Class

#### Initial Thoughts
When implementing wallet feature, I found out that if I put both validation and business logic in controller it will be too hard to read. So service class is added to support validation with simple command, and only writes core logic in the main function.

#### Follow up Thoughts
There are inconsistent use of service class in this project, and will be the todos for this project:
1. User feature should be implemented with service class, but it is now implemented in controller.
2. Wallet feature for reading data should be implemented with finder class (similar to service but will be only used for reading database), but it is now implemented in controller.

### Using Pessimistic Lock Instead of Optimistic Lock

#### Initial Thoughts
Using pessimistic lock is more straightforward to me at the time I implemented the feature.

#### Follow up Thoughts
Optimistic lock has less overhead and does not risk dead locking. If the frequency of changing wallet is low, using optimistic lock would be better than pessimistic lock.

### Store Transfer Transaction History for Both User

#### Initial Thoughts
Storing 1 transaction event for 1 transfer operation will require filtering 2 fields (source wallet & target wallet) to find all the transactions for 1 wallet. But storing changes on both sides with 2 record will only have to inspect only 1 field, which is more efficient.


## Project Working Time

1. [30min] Project planning.
2. [60min] Refine user story, explore requirements, define acceptance criteria.
3. [70min] Setup rails project, environment, boot scripts.
4. [240min] Develop user feature, jwt token, authentication middleware.
5. [360min] Develop wallet feature.
6. [240min] Review and write summary for this work.


## Areas to Improve

### Testing
- Write unit test for service class.
- Removing error message check from test.
- Specify HTTP status to be returned in controller tests.

### Software Design
- Add validation to active record.
- Create finder class to hold query operation.
- Move user business logic from controller to service class.

### Table / Database
- Consider using uid string for all table for better scalability.
- Set database character to UTF-8.

### Feature
- Migrate money type from integer to decimal.
- The amount in transaction events should be negative for transfer out and withdraw.
- Add metadata (e.g. source username) to transaction event table for better user experience.
- Support multi wallet.
- Support user password.

### Settings
- Optimize environment settings under config/*

### CI/CD
- Add test to CI
