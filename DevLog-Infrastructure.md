2024/12/21 10:08~2024/12/21 10:30
# Project Planning

Review user story and RESTful API requirements: The functional requirement is clear,
but non-functional requriements and edge cases aren't provided.
Review mandatory: Ruby will be chose as I'm more comfortable with it.
Review other requirements: User and wallet info should be persistent.

Considering the scoring information provided, I plan to complete the project with
the following stage:
1. Explore and decide different concern for the application.
2. Refine user story, explore and decide functional and non-functional requirements,
acceptance criteria, follow ups.
3. Explore, select and explain the technology I'll be used.
4. Setup project and boot scripts.
5. Explore and define development flow I'll used in the following work.
6. Develop common concerns
7. Develop features.
8. Review and write summary for this work.

All steps should provide:
1. Areas to be improved.
2. Time spent
3. Decision affects requirements, and those not.
4. Always provide summary for each step to provide only valuable information.


2024/12/21 10:46 ~ 2024/12/21 10:59
# 1 Explore Common Concerns

## Security
Always require user login.
The login state will be checked against bearer token.

## Logging
Always log incoming request.

## Error Handling
Intercept error raised at middleware, log it and fill lazy response if needed.


2024/12/21 11:32 ~ 2024/12/21 12:25
# 2 Refine Requirements

## Explore General/Common Requirements
- There are 3 entities can be found from the requirements:
  1. User
  2. Wallet
  3. Transaction
- All the money will be integer for simplicity
- The lower limit of balance is 0, the upper limit of balance is 999,999,999.

## AC for each story

### User can deposit money into his/her wallet
1. User deposit 1 to empty wallet should be accepted, transaction record should be created.
2. User deposit 1 to wallet with 999,999,999 should be rejected.
3. User deposit 1 to empty wallet with 100 parallel request should add 100 in wallet.
4. User deposit 0 should be rejected due to trivial operation.
5. User deposit 1,000,000,000 should be rejected due to invalid amount.
6. User deposit -1 should be rejected due to invalid amount.
7. User deposit 0.5 should be rejected due to incorrect amount type.
8. User deposit "abc" should be rejected due to incorrect amount type.

### User can withdraw money from his/her wallet
1. User withdraw 1 from empty wallet should be rejected.
2. User withdraw 1 from non-empty wallet should be accepted, transaction record should be created.
3. User withdraw 1 from wallet with 100 parallel request should decrease 100 from wallet. (assume the wallet has enough money for withdraw)
4. User withdraw 0 from wallet should be rejected.
5. User withdraw 1,000,000,000 should be rejected due to invalid amount.
6. User withdraw -1 from wallet should be rejected.
7. User deposit 0.5 should be rejected due to incorrect amount type.
8. User deposit "abc" should be rejected due to incorrect amount type.

### User can send money to another user
1. A sends B 1, if A has 1 and B has 0, operation should succeed, result in A has 0 and B has 1, transaction record should be created.
2. A sends B 1, if A has 0 and B has 0, request rejected due to insufficient money from A, both wallet should remain the same.
3. A sends B 1, if A has 1 and B has 999,999,999, request rejected due to full wallet from B, both wallet should remain the same.
4. A sends B 0, reject for trivial operation.
5. A sends B 1,000,000,000, reject for invalid amount.
5. A sends B -1, reject for invalid amount.
6. A sends B 1, but B does not exist.

### User can check his/her wallet balance
1. A has 0, request balance should return 0.
2. A has 999,999,999, request balance should return 999,999,999.
3. A has 0, run the following operation:
  1. Check A's balance should result in 0.
  2. Deposit 100 to wallet.
  3. Check A's balance should result in 100.
  4. Withdraw 50 from wallet.
  5. Check A's balance should reseult in 50.
  6. B sends A 50.
  7. Check A's balance should result in 100.
  8. A sends B 100.
  9. Check A's balance should result in 0.

### User can view his/her transaction history
1. User with no transaction history should get empty result.
2. User with 51 transaction histories should get 50 first, and 1 for the next page.


2024/12/21 12:45 ~ 2024/12/21 12:50
# 3 Selected Technology

1. Language: Ruby (familiar to me)
2. Web application framework: Ruby on Rails (familiar to me)
3. Database: PostgreSQL (required by assessment)
4. Local development environment: Docker


2024/12/21 12:51 ~ 2024/12/21 14:00
# 4 Setup Project And Boot Scripts

## Setup Rails Application
* Supported by GPT
1. Initialize Ruby on Rails: `docker run --rm -v "$(pwd)":/app -w /app ruby:3.2 bash -c "gem install rails && rails new . --database=postgresql --api"`
2. Security and flexibility is ignored for simplicity.
3. Setup Dockerfile, docker-compose
4. The app can now boot up by running `docker-compose up --build`

## Setup Rspec
1. Modify Gemfile, add rspec and related package.
2. Install by docker-compose build
3. Initialize rspec with docker-compose run web bin/rails generate rspec:install
4. setup database.yml
5. Setup test db `docker-compose run web bin/rails db:setup RAILS_ENV=test`
6. Verify test database `docker-compose exec db psql -U postgres -d myapp_test -c '\dt'`
7. Add test file and launch rspec with `docker-compose run web bin/rspec spec/example/example_spec.rb`

## Setup Makefile
1. Setup Makefile


2024/12/21 14:01 ~ 2024/12/21 14:05
# 5 Define Development Flow
1. List changes, and refine requirements if needed.
2. Write test for current feature.
3. Develop the simplest working solution.
4. Refactor if needed.
5. Write dev logs, note, comments if needed.


2024/12/21 14:53 ~ 2024/12/21 16:45
2024/12/21 17:31 ~ 2024/12/21 19:20
2024/12/22 10:27 ~ 2024/12/22 10:46
# 6 Develop common concerns

## Security

### Changes
1. Create user table
2. Create authentication concern
3. Create signup endpoint
4. Create login endpoint

### Implementation
1. Create user table
  1. Table Design
    - table name: users
    - columns:
      - id
      - updated_at
      - created_at
      - username, :string
    - index:
      - username
2. Create authentication concern
  1. Create jwt utils
    - Interfaces
      1. encode: encode payload to token
      2. decode: decode token
    - AC
      1. encode hash should give string
      2. decode encoded token should give original info
  2. Create user context
  3. Create middleware
    - Logic
      1. Verifying bearer token.
      2. Inject user info to context.
    - AC
      1. Request with valid token should have user injected into context
      2. Request with invalid token should return 401
3. Create signup endpoint
  1. POST /v1/user/sign_up
    - Request body: (1) username: string
    - Response body: (1) status: string (2) message: string (2) data.token: string
    - Logic:
      1. Check if username is registered, if so, return 400 Registered.
      2. Create user with username in database.
      3. Generate bearer token
    - AC:
      1. Sign up with unregistered username should succeed.
      2. Sign up with registered username should fail and get 400.
4. Create login endpoint
  1. POST /v1/user/login
    - Request body: (1) username
    - Response body: (1) status: string (2) message: string (3) data.token: string
    - Logic:
      1. Find user by username, if not found return 400 not found with message
      2. Generate bearer token
    - AC:
      1. Login with registered username should succeed.
      2. Login with unregistered username should return 400.
note: 40 min taken

### Development
1. Create user table
  1. Add gem annotaterb.
  2. Generate user model
2. Create authentication concern
  1. Create jwt utils (Support by GPT)
    1. Add jwt utils and tests
  2. Create user context
  3. Create middleware
3. Create signup endpoint
  1. Configure routes.rb
  2. Implement signup endpoint
  3. Write tests (Support by GPT)
4. Create login endpoint
note: 181 min taken

## Logging

Logging request before processing is important for monitoring and
debugging, fields like user info and request payload which is not available
from gateway access log are important info to be stored.
But for this project we'll only run in development environment, logging doesn't
affect business functionality nor debugging experience so I'll skip this concern
here.

## Error Handling

### Changes
1. Rescue all StandardError and return error message and traceback in simpler
format to make debug easier both in test stage and serving stage.

### Development
1. Create middleware handles StandardError exception and return message and
traceback only.
2. Add test
