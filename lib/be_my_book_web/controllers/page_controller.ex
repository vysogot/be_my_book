defmodule BeMyBookWeb.PageController do
  use BeMyBookWeb, :controller

  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset, only: [change: 2]

  alias Phoenix.HTML
  alias BeMyBook.Repo
  alias BeMyBook.Book

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

    title = EntropyString.token(:charset32)
            |> String.slice(0..3)

    Repo.insert!(%Book{title: title, contents: links})

    link = Routes.url(conn) <> conn.request_path
          |> String.replace("/api", "")
          |> Kernel.<>(title)

    json(conn, link)
  end

  def show_without_title(conn, params) do
    redirect(conn, to: "/" <> params["slug"] <> "/1")
  end

  def show(conn, params) do
    query = from b in Book,
      where: b.title == ^params["slug"]

    %{ contents: result } = Repo.one(query)

    current_page = String.to_integer(params["page"])
    current_index = current_page - 1
    page = Enum.at(result, current_index)

    {:ok, %HTTPoison.Response{body: body}} = HTTPoison.request(:get,
      page["link"],
      "", [], [follow_redirect: true, hackney: [{:force_redirect, true}]]
    )

    title = page["title"]
            |> HTML.html_escape
            |> HTML.safe_to_string
    body = body
           |> HTML.html_escape
           |> HTML.safe_to_string
           |> String.replace("\n", "</p><p>")

    next_page = if current_page + 1 > Enum.count(result), do: 1, else: current_page + 1
    prev_page = if current_page <= 0, do: Enum.count(result) + 1, else: current_page - 1

    prev_url = Routes.page_path(conn, :show, params["slug"], prev_page)
    next_url = Routes.page_path(conn, :show, params["slug"], next_page)

    render(conn, "show.html", %{
      title: title,
      body: body,
      next_url: next_url,
      prev_url: prev_url
    })
  end
end
