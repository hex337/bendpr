defmodule Bendpr.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    slack_token = Application.get_env(:bendpr, Bendpr.Slack)[:token]

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      #supervisor(Bendpr.Repo, []),
      # Start the endpoint when the application starts
      supervisor(BendprWeb.Endpoint, []),
      # Start your own worker by calling: Bendpr.Worker.start_link(arg1, arg2, arg3)
      # worker(Bendpr.Worker, [arg1, arg2, arg3]),
      %{
        id: Slack.Bot,
        start: {Slack.Bot, :start_link, [Bendpr.SlackRtm, [], slack_token] }
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bendpr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BendprWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
