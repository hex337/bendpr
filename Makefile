.PHONY: test run

run: # Run the bot
	docker-compose run --rm -e SLACK_TOKEN=`echo $(SLACK_TOKEN)` -e GITHUB_TOKEN=`echo $(GITHUB_TOKEN)` web mix run --no-halt
