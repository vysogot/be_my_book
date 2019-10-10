defmodule BeMyBookWeb.PageControllerTest do
  use BeMyBookWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "BeMyBook"
  end

  test "POST /api", %{conn: conn} do
    conn = post(conn, "/api/", [urls: %{}])
    assert json_response(conn, 200) =~ ~r/[a-zA-Z0-9]{4}\/1/
  end
end
