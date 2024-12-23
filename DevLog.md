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


# 2 Refine Requirements
See DevLog-refineRequirements.md


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


# 6 Develop common concerns
See DevLog0commonConcern.md


# 7 Develop feature
See DevLog-feature.md


# 8 Review and write summary for this work.

## Todo
1. Write readme.md
  0. Fix dead lock issue
  1. Launching environment
  2. Feature navigation
  3. Project navigation
  4. Decision explanation
  5. Working time summary
  6. List todos
