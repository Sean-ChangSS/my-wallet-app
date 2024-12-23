build:
	docker-compose build

db_create:
	docker-compose run web bin/rails db:create

db_migrate:
	docker-compose run web bin/rails db:migrate

up:
	docker-compose up web --force-recreate

down:
	docker-compose down

test:
	docker-compose run --rm test bin/rspec

testwith:
	docker-compose run --rm test bin/rspec $(DEST)