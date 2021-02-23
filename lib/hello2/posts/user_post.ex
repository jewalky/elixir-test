defmodule Hello2.Posts.UserPost do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "user_posts" do
    field :title, :string
    field :text, :string
    field :user_id, :binary_id
    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:title, :text, :user_id])
    |> validate_required([:text])
  end
end
