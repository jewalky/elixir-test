defmodule Hello2.Posts do
  alias Hello2.Repo
  alias Hello2.Posts.UserPost
  import Ecto.Query, only: [from: 2]

  def create_post(attrs \\ %{}) do
    %UserPost{}
    |> UserPost.changeset(attrs)
    |> Repo.insert()
  end

  def get_posts(limit \\ 25) do
    query =
      from p in UserPost,
        order_by: [desc: :inserted_at],
        limit: ^limit

    Repo.all(query)
  end
end
