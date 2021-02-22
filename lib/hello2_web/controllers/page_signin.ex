defmodule Hello2Web.PageSignin do
  use Hello2Web, :controller
  alias Hello2.Auth

  def index(conn, _params) do
    render(conn, "signin.html", csrf_token: get_csrf_token())
  end

  def process(conn, _params) do
    case _params do

      %{"user_name" => user_name, "password" => password} ->
        case Auth.signin_user(%{user_name: user_name, password: password}) do
          {:ok, user} ->
            put_session(conn, :user_id, user.id)

          {:error, error} -> render(conn, "signin.html", csrf_token: get_csrf_token(), error: error)
        end

      _ -> render(conn, "signin.html", csrf_token: get_csrf_token(), error: "Bad request")

    end
  end

end
