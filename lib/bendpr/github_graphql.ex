defmodule Bendpr.GithubGraphql do
  def open_prs_for_user(github_handle) do
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

    send_query(query)
  end

  def send_query(query) do
    github_token = Application.get_env(:bendpr, Bendpr.Slack)[:github]
    url = "https://api.github.com/graphql"
    headers = ["Authorization": "bearer #{github_token}", "Content-Type": "application/json"]

    {_, body} = JSON.encode([query: query])
    {:ok, response} = HTTPoison.post(url, body, headers)
    {_, github_response} = JSON.decode(response.body)

    github_response
  end
end
