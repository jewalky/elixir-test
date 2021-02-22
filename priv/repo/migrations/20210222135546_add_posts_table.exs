defmodule Hello2.Repo.Migrations.AddPostsTable do
  use Ecto.Migration

  def change do
    create table("user_posts") do
      add :title, :string
      add :text, :string
      add :user_id, references(:users)
      timestamps()
    end
  end
end
