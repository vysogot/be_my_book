defmodule BeMyBook.Repo do
  use Ecto.Repo,
    otp_app: :be_my_book,
    adapter: Ecto.Adapters.Postgres
end
