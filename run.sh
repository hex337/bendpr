#!/bin/sh

set -e
# Sleep to let the db server come up a second time
sleep 5
mix ecto.create
mix ecto.migrate
mix phx.server
