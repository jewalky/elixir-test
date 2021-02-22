defmodule Hello2.Repo do
  use Ecto.Repo,
    otp_app: :hello2,
    adapter: Ecto.Adapters.Postgres
end
