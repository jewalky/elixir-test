defmodule Hello2.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field :user_name, :string
    field :password, :string
    field :plain_password, :string, virtual: true
    field :display_name, :string
    has_many :user_posts, Hello2.Posts.UserPost
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:user_name, :plain_password, :display_name])
    |> validate_required([:user_name])
    |> ensure_hashed_password()
    |> ensure_uuid()
  end

  defp ensure_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{plain_password: plain_password}} ->
        put_change(changeset, :password, :crypto.hash(:sha, plain_password) |> Base.encode16(case: :lower))
      _ -> changeset
    end
  end

  def ensure_uuid(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{id: _}} -> changeset
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :id, Ecto.UUID.generate)
      _ -> changeset
    end
  end

  def hash_password(password) do
    :crypto.hash(:sha, password) |> Base.encode16(case: :lower)
  end

end
