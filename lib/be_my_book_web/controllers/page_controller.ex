defmodule BeMyBookWeb.PageController do
  use BeMyBookWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, _params) do
    links = _params["urls"]
            |> Enum.map fn {_, v} -> { v["name"], v["link"] } end

    #require IEx; IEx.pry
    [head | _] = links
    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.request(:get,
      "https://www.dropbox.com/s/o0fhensn1yly6mk/powie%C5%9B%C4%87.txt?dl=1",
      "", [], [follow_redirect: true, hackney: [{:force_redirect, true}]]
    )

    json(conn, body)
  end
end
