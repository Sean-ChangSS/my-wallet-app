
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
6. A sends B -1, reject for invalid amount.
7. A sends B 1, but B does not exist.

### User can check his/her wallet balance
1. A has 0, request balance should return 0.
2. A has 999,999,999, request balance should return 999,999,999.
3. A has 0, and is updated to 100, request balance should return 100.

### User can view his/her transaction history
1. User with no transaction history should get empty result.
2. User with 51 transaction histories should get 50 first, and 1 for the next page.
