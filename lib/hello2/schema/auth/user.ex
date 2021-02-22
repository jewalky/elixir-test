defmodule Hello2.User do
  use Ecto.Schema

  schema "users" do
    field :user_name, :string
    field :password, :string
    field :plain_password, :string, virtual: true
    field :display_name, :string
    has_many :user_posts, Hello2.UserPost
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:user_name, :plain_password, :display_name])
    |> hash_password()
  end

  defp hash_password(user) when is_map(user) do
    user["password"] = :crypto.hash(:sha, user["plain_password"]) |> Base.encode16(case: :lower)
  end

end
