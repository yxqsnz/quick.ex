defmodule QuickEx.Quick do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "quicks" do
    field :data, :string
    field :delete_token, :string
    field :qid, :string
    field :views, :integer

    timestamps()
  end

  @doc false
  def changeset(quick, attrs) do
    quick
    |> cast(attrs, [:qid, :data, :views, :delete_token])
    |> validate_required([:qid, :data, :views, :delete_token])
  end
end
