defmodule Hello2Web.PageSignout do
  use Hello2Web, :controller
  alias Hello2.Auth

  def index(conn, _params) do
    case get_session(conn, :user_id) do
      nil ->
        redirect(conn, to: "/")

      _ ->
        conn
        |> clear_session()
        |> redirect(to: "/")
    end
  end
end
