defmodule Hello2.UserPost do
  use Ecto.Schema

  schema "user_posts" do
    field :title, :string
    field :text, :string
    belongs_to :user_id, Hello2.User
  end
end
