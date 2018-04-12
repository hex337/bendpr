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
    token = Application.get_env(:bendpr, Bendpr.Slack)[:token]

    if text =~ "open prs" do
      IO.puts "Someone is asking about open prs."

      client = Tentacat.Client.new(%{access_token: Application.get_env(:bendpr, Bendpr.Slack)[:github]})
      pr_attachments = Tentacat.Pulls.filter("1debit", "server-core", %{state: "open"}, client)
                       |> Parser.parse_prs
                       |> Enum.map(fn(pr) -> pr_to_attachment(pr) end)
                       |> JSX.encode!

      IO.puts inspect(pr_attachments, pretty: true)

      Slack.Web.Chat.post_message(message.channel, "Current open PR's:", %{
        token: token,
        attachments: [pr_attachments]
      })
    end
    
    if text =~ "my prs" do
      IO.puts "#{user} is asking about their prs."

      github_handle = Bendpr.SlackUserToGithubHandle.map_user(user)
      IO.puts github_handle

      github_token = Application.get_env(:bendpr, Bendpr.Slack)[:github]
      Neuron.Config.set(headers: ["Authorization": "bearer #{github_token}"])
      Neuron.Config.set(url: "https://api.github.com/graphql")

      query = """
query {
  user(login: \"#{github_handle}\") {
    pullRequests(first: 10, states: OPEN) {
      edges {
        node {
          title
          url
          headRepository {
            name
          }
        }
      }
    }
  }
}
"""

      url = "https://api.github.com/graphql"
      headers = ["Authorization": "bearer #{github_token}", "Content-Type": "application/json"]
      {_, body} = JSON.encode([query: query])
      {:ok, response} = HTTPoison.post(url, body, headers)

      {_, github_response} = JSON.decode(response.body)
      IO.puts inspect(github_response, pretty: true)

      pr_attachments = github_response
                       |> Parser.parse_graphql_prs
                       |> Enum.map(fn(pr) -> pr_to_attachment(pr) end)
                       |> JSX.encode!

      Slack.Web.Chat.post_message(message.channel, "Your open PR's:", %{
        token: token,
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
