defmodule Bendpr.SlackRtm do
  use Slack

  alias Bendpr.Parser
  alias Bendpr.GithubGraphql

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}."
    { :ok, state }
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    IO.puts "There was a message."
    text = message.text
    slack_token = Application.get_env(:bendpr, Bendpr.Slack)[:token]

    if text =~ "my prs" && Map.has_key?(message, :user) do
      # There's no user key for bot messages
      user = message.user
      IO.puts "#{user} is asking about their prs."

      github_handle = Bendpr.SlackUserToGithubHandle.map_user(user)
      github_response = GithubGraphql.open_prs_for_user(github_handle)

      IO.puts inspect(github_response, pretty: true)

      pr_attachments = github_response
                       |> Parser.parse_graphql_prs
                       |> Enum.map(fn(pr) -> pr_to_attachment(pr) end)
                       |> JSX.encode!

      Slack.Web.Chat.post_message(message.channel, "Your open PR's:", %{
        token: slack_token,
        attachments: [pr_attachments]
      })
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

  def pr_to_attachment(pr) do
    %{
      "title": pr.title,
      "pretext": pr.head_repo,
      "title_link": pr.url,
      "color": "#36a64f"
    }
  end
end
