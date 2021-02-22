defmodule Hello2.Auth do

  alias Hello2.Repo
  alias Hello2.Auth.User
  import Ecto.Query, only: [from: 2]

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def signin_user(%{user_name: user_name, password: password}) do
    hashed_password = User.hash_password(password)
    query = from u in User,
      where: u.password == ^hashed_password and u.user_name == ^user_name
    case Repo.all(query) do
      [user|_] -> {:ok, user}
      _ -> {:error, "Invalid credentials"}
    end
  end

end
