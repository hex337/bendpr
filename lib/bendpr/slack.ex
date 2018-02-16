defmodule Bendpr.SlackRtm do
  use Slack

  alias Bendpr.Parser

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}."
    { :ok, state }
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    IO.puts "There was a message."
    IO.puts inspect(message, pretty: true)
    user = message.user
    text = message.text

    if text =~ "open prs" do
      IO.puts "Someone is asking about open prs."

      client = Tentacat.Client.new(%{access_token: Application.get_env(:bendpr, Bendpr.Slack)[:github]})
      pr_links = Tentacat.Pulls.filter "1debit", "server-core", %{state: "open"}, client
                 |> Parser.parse_prs

      IO.puts inspect(pr_links, pretty: true)
    end

    { :ok, state }
  end

  def handle_event(_, _, state), do: { :ok, state }

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "sending your message"

    send_message(text, channel, slack)

    { :ok, state }
  end

  def handle_info(_, _, state), do: { :ok, state }
end
