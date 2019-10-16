defmodule BeMyBookWeb.PageControllerTest do
  use BeMyBookWeb.ConnCase
  use BeMyBook.RepoCase
  alias BeMyBook.Repo

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "BeMyBook"
  end

  test "POST /api", %{conn: conn} do
    conn = post(conn, "/api/", [urls: %{}])
    assert json_response(conn, 200) =~ ~r/[a-zA-Z0-9]{4}\/1/
  end

  test "GET /:title", %{conn: conn} do
    Repo.insert!(%BeMyBook.Book{
      title: "XYZ1",
      contents: [%{ "title" => "One", "link" => "url" }]
    })

    with_mock HTTPoison do
      conn = get(conn, "/" <> "XYZ1" <> "/1")
    end
    assert html_response(conn, 200) =~ "One"
  end
end
