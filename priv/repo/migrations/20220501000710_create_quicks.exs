defmodule QuickEx.Repo.Migrations.CreateQuicks do
  use Ecto.Migration

  def change do
    create table(:quicks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :qid, :string
      add :data, :string
      add :views, :integer
      add :delete_token, :string

      timestamps()
    end
  end
end
