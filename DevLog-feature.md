2024/12/22 10:48 ~ 2024/12/22 12:55
2024/12/22 14:19 ~ 2024/12/22 16:00
2024/12/22 16:20 ~
# 7 Develop feature

## Deposit to specify user wallet

### Changes
1. Add wallet model
2. Add wallet controller
3. Register user should create wallet too
4. Write test and implement business logic

### Implementation
1. Add wallet model
  - Table name: wallets
  - Table Schema:
    - id
    - updated_at
    - created_at
    - user_id, integer, null: false
    - balance, integer, null: false
2. Add wallet controller
3. Create user will create wallet
4. Write test and implement business logic
  1. Implement BaseService to handle validation and wrap core logic
  2. Add type validator
  3. Add auth helper to deal with authentication before request.
  4. Write core logic and tests
note: 120 min spent

## Withdraw from specify user wallet

### Changes
1. Write test and implement business logic

### Implementation
1. Write test and implement business logic
note: 20min spent

## Transfer from one user to another user

### Changes
1. Write test and implement business logic

### Implementation
1. Write test and implement business logic
note: 60 min spent

## Get specify user balance

### Changes
1. Write test and implement business logic

### Implementation
1. Write test and implement business logic
note: 10 min spent

## Get specify user transaction history

### Changes
1. Add Transaction Model
2. Add get history transaction endpoint
3. Record transaction for all wallet service

### Implementation
1. Add Transaction Model
  1. Design TransactionEvent Model
    - Table name: transactions
    - Table Fields:
      - id
      - created_at
      - wallet_id: integer, non-null
      - source_wallet_id: integer
      - amount: integer, non-null
      - balance: integer, non-null
      - transaction_type: integer, non-null
    - Index:
      wallet_id, created_at
2. Add get history transaction endpoint
  1. Add pagination gem
  2. Write test and get transaction logic
