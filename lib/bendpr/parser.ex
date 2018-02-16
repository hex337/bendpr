defmodule Bendpr.Parser do
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
    %{"_links" => %{"html" => %{"href" => url}}} = input
    url
  end

  def extract(:title, input) do
    %{"title" => title} = input
    title
  end

  def extract(:author, input) do
    %{"user" => user} = input
    construct_user_map(user)
  end

  def extract(:reviewers, input) do
    %{"requested_reviewers" => revs} = input
    Enum.map(revs, &construct_user_map/1)
  end

  def construct_user_map(user) do
    %{"login" => username} = user
    %{"id" => id} = user

    %{
      username: username,
      id: id
    }
  end

  defp construct_map(url, title, author, reviewers) do
    %{
      url: url,
      title: title,
      author: author,
      reviewers: reviewers
    }
  end
end
