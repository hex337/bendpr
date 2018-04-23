defmodule Bendpr.SlackUserToGithubHandle do

  def map_user(user) do
    user_mapping = %{
      "U6EFE69U6" => "hex337"
    }

    user_mapping[user]
  end
end
