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
