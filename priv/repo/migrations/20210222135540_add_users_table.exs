defmodule Hello2.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table("users") do
      add :user_name, :string
      add :password, :string
      add :display_name, :string
    end
  end
end
