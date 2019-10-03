defmodule BeMyBookWeb.PageController do
  use BeMyBookWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, _params) do
    links = _params["urls"]
            |> Enum.map fn {k, v} -> %{
              title: v["name"],
              link: v["link"]
              |> String.slice(0..-2)
              |> Kernel.<>("1")
            } end

    #require IEx; IEx.pry
    #|> Enum.sort_by(&(&1))

    length = 4
    title = :crypto.strong_rand_bytes(length)
            |> Base.encode64
            |> binary_part(0, length)

    :ets.insert(:books, { title, links })

    link = Routes.url(conn) <> conn.request_path
          |> String.replace("/api", "")
          |> Kernel.<>(title)

    json(conn, link)
  end

  def show_without_title(conn, _params) do
    redirect(conn, to: "/" <> _params["slug"] <> "/1")
  end

  def show(conn, _params) do
    [{ _, result }] = :ets.lookup(:books, _params["slug"])
    current_page = String.to_integer(_params["page"])
    current_index = current_page - 1
    page = Enum.at(result, current_index)

    title = page[:title]
            |> String.slice(0..-5)
            |> String.capitalize

    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.request(:get,
      page[:link],
      "", [], [follow_redirect: true, hackney: [{:force_redirect, true}]]
    )

    body = body |> String.replace("\n\t", "</p><p>")

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
