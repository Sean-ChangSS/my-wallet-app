up:
	docker-compose up --force-recreate

down:
	docker-compose down

test:
	docker-compose run --rm test bin/rspec

testwith:
	docker-compose run --rm test bin/rspec $(DEST)