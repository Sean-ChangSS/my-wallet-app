2024/12/22 10:48 ~ 
# 7 Develop feature

## Deposit to specify user wallet

### Changes
1. Add wallet model
2. Add wallet controller
3. Add test
4. Register user should create wallet too
5. Implement logic to satisfy test

### Implementation
1. Add wallet model
  - Table name: wallets
  - Table Schema:
    - id
    - updated_at
    - created_at
    - user_id, integer, null: false
    - balance, integer, null: false

## Withdraw from specify user wallet

## Transfer from one user to another user

## Get specify user balance

## Get specify user transaction history
