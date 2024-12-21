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
4. Setup scripts to boot services with one tap.
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

### User can withdraw money from his/her wallet
1. User withdraw 1 from empty wallet should be rejected.
2. User withdraw 1 from non-empty wallet should be accepted, transaction record should be created.
3. User withdraw 1 from wallet with 100 parallel request should decrease 100 from wallet. (assume the wallet has enough money for withdraw)
4. User withdraw 0 from wallet should be rejected.
5. User withdraw 1,000,000,000 should be rejected due to invalid amount.
6. User withdraw -1 from wallet should be rejected.

### User can send money to another user
1. A sends B 1, if A has 1 and B has 0, operation should succeed, result in A has 0 and B has 1, transaction record should be created.
2. A sends B 1, if A has 0 and B has 0, request rejected due to insufficient money from A, both wallet should remain the same.
3. A sends B 1, if A has 1 and B has 999,999,999, request rejected due to full wallet from B, both wallet should remain the same.
4. A sends B 0, reject for trivial operation.
5. A sends B 1,000,000,000, reject for invalid amount.
5. A sends B -1, reject for invalid amount.

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
