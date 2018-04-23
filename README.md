# Bendpr

A slack bot to help you manage your github PR flow.

## Docker Setup

### Set up your .env file

```shell
cp .env.example .env
```

Open up the `.env` file and add your keys/tokens.

### Build the Container

```shell
docker-compose build
```

### Running the bot

```shell
make run
```

This assumes you have `SLACK_TOKEN` and `GITHUB_TOKEN` set up as environment variables.

## Configuration

### Add a new bot to your Slack Organization

You'll need to add a new bot integration for your Slack Org, where you'll get your `SLACK_TOKEN`.

### Mapping Slack User id to GitHub id

In order to notify and pull the right information, you'll have to set up a mapping for slack ids to github usernames.

Open up `lib/bendpr/slack_user_to_github_handle.ex` and edit the `map_user` function.

You can find your slack id by inspecting the message payload in the console where the bot is running.

Example output:

```
%{channel: "G80R60UKV", source_team: "T6CUTBQ3A", team: "T6CUTBQ3A",
  text: "my prs", ts: "1523493993.000177", type: "message", user: "U6EFE69U6"}
```

The Slack user id is U6EFE69U6 in this instance.

*TODO* Make this more automatic or better.

### Setting up Notification Preferences

There are three notification settings: default, constant, and daily.

The `default` option queues up notifications about new PR's, comments, and review requests and notifies the recpient once per hour with any updates.

The `constant` option notifies the recipient every time something happens.

The `daily` options notifies once per day.

### GitHub Webhooks

You'll need to enable a webhook for your organisation to get real time information about PR's.

*TODO* Add instructions on how to do that.

## Features

### Ask about your open PR's

Ask BendPR about "my prs" to get a list of all your open pr's.

### Ask about PR's that you need to review

Ask BendPR about "prs to review" to get a list of all pr's where you're a requested reviewer.

## Contributing

Any contributions are welcome! I'll try to keep the issues list up to date with things we want to add along with some prioritization.

### Running Tests

*TODO* Add tests and add a way to run them.
