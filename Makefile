.PHONY: test run

run: # Run the bot
	docker-compose run --rm -e SLACK_TOKEN=$(SLACK_TOKEN) -e GITHUB_TOKEN=$(GITHUB_TOKEN) web mix run --no-halt
