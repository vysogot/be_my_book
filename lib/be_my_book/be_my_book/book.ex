defmodule BeMyBook.Book do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  schema "books" do
    field :contents, { :array, :map }
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Book{} = book, attrs) do
    book
    |> cast(attrs, [:title, :contents])
    |> validate_required([:title, :contents])
  end
end
