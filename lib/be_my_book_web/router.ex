defmodule BeMyBookWeb.Router do
  use BeMyBookWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BeMyBookWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/:slug", PageController, :show
  end

  # Other scopes may use custom stacks.
  scope "/api", BeMyBookWeb do
    pipe_through :api

    post "/", PageController, :create
  end
end
