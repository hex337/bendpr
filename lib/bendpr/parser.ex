defmodule Bendpr.Parser do
  def parse_graphql_prs(graphql_response) do
    %{"data" => %{"user" => %{"pullRequests" => %{"edges" => prs}}}} = graphql_response
    IO.puts inspect(prs, pretty: true)

    prs
    |> Enum.map(&extract_from_graphql/1)
  end

  def extract_from_graphql(input) do
    url = extract(:url, input)
    title = extract(:title, input)
    head_repo = extract(:head_repo, input)
    reviewers = []

    construct_map(url, title, head_repo, reviewers)
  end

  def parse_prs(prs) do
    prs
    |> Enum.map(&extract_and_construct/1)
  end

  def extract_and_construct(input) do
    url = extract(:url, input)
    title = extract(:title, input)
    author = extract(:author, input)
    reviewers = extract(:reviewers, input)

    construct_map(url, title, author, reviewers)
  end

  def extract(:url, input) do
    %{"node" => %{"url" => url}} = input
    url
  end

  def extract(:title, input) do
    %{"node" => %{"title" => title}} = input
    title
  end

  def extract(:head_repo, input) do
    %{"node" => %{"headRepository" => %{"name" => head_repo}}} = input
    head_repo
  end

  defp construct_map(url, title, head_repo, reviewers) do
    %{
      url: url,
      title: title,
      head_repo: head_repo,
      reviewers: reviewers
    }
  end
end
