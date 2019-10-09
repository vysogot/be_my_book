defmodule BeMyBook.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :contents, { :array, :map }

      timestamps()
    end

  end
end
