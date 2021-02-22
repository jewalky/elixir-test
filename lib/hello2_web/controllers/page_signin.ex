defmodule Hello2Web.PageSignin do
  use Hello2Web, :controller
  import Hello2.Auth

  def index(conn, _params) do
    render(conn, "signin.html", csrf_token: get_csrf_token())
  end

  def process(conn, _params) do
    case _params do

      %{"user_name" => user_name, "password" => password} ->
        user = Auth.signin_user(_params)
        IO.inspect(user)
        redirect(conn, to: "/signin")

      _ -> render(conn, "signin.html", csrf_token: get_csrf_token(), error: "Bad request")

    end
  end

end
