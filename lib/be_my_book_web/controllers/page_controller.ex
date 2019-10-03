defmodule BeMyBookWeb.PageController do
  use BeMyBookWeb, :controller

  alias Phoenix.HTML

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, params) do
    links = params["urls"]
            |> Enum.map(fn {_, v} -> %{
              title: v["name"]
              |> String.slice(0..-5)
              |> String.capitalize,
              link: v["link"]
              |> String.slice(0..-2)
              |> Kernel.<>("1")
            } end)
            |> Enum.sort_by(&(&1.title))

    # require IEx; IEx.pry

    title = EntropyString.token(:charset32)
            |> String.slice(0..3)

    :ets.insert(:books, { title, links })

    link = Routes.url(conn) <> conn.request_path
          |> String.replace("/api", "")
          |> Kernel.<>(title)

    json(conn, link)
  end

  def show_without_title(conn, params) do
    redirect(conn, to: "/" <> params["slug"] <> "/1")
  end

  def show(conn, params) do
    [{ _, result }] = :ets.lookup(:books, params["slug"])
    current_page = String.to_integer(params["page"])
    current_index = current_page - 1
    page = Enum.at(result, current_index)

    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.request(:get,
      page[:link],
      "", [], [follow_redirect: true, hackney: [{:force_redirect, true}]]
    )

    title = page[:title]
            |> HTML.html_escape
            |> HTML.safe_to_string
    body = body
           |> HTML.html_escape
           |> HTML.safe_to_string
           |> String.replace("\n", "</p><p>")

    next_page = if current_page + 1 > Enum.count(result), do: 1, else: current_page + 1
    prev_page = if current_page <= 0, do: Enum.count(result) + 1, else: current_page - 1

    url = Routes.url(conn) <> conn.request_path
    next_url = url
               |> String.slice(0..-2)
               |> Kernel.<>(Integer.to_string(next_page))
    prev_url = url
               |> String.slice(0..-2)
               |> Kernel.<>(Integer.to_string(prev_page))

    render(conn, "show.html", %{
      title: title,
      body: body,
      next_url: next_url,
      prev_url: prev_url
    })
  end
end
