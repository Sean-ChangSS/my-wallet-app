

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