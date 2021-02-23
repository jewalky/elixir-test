defmodule Hello2Web.PageSigninView do
  use Hello2Web, :view

  def render("signin.html", assigns) do
    ~L"""

    <div class="signin-window">

      <h1>Sign in</h1>

      <form method="POST">
        <input type="hidden" value="<%= @csrf_token %>" name="_csrf_token"/>
        <label>Username: <input type="text" name="user_name"></label>
        <label>Password: <input type="password" name="password"></label>
        <input type="submit" value="Sign in">
      </form>

    </div>

    """
  end
end
