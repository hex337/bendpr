defmodule BendprWeb.Router do
  use BendprWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BendprWeb do
    pipe_through :api
  end
end
