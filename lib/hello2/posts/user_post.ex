defmodule Hello2.Posts.UserPost do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "user_posts" do
    field :title, :string
    field :text, :string
    field :user_id, :string
  end
end
