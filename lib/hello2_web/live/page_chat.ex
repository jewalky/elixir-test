defmodule Hello2Web.PageChat do
  use Hello2Web, :live_view
  alias Hello2.Auth
  alias Hello2.Posts

  @ps_channel "chat_notifications"

  @impl true
  def mount(_params, session, socket) do
    Hello2Web.Endpoint.subscribe(@ps_channel)

    socket =
      case session do
        %{"user_id" => user_id} ->
          socket
          |> assign(
            user:
              case Auth.fetch_user(user_id) do
                {:ok, user} -> user
                {:error, _} -> nil
              end
          )

        _ ->
          socket
          |> assign(user: nil)
      end

    # fetch initial messages from DB
    # message: { date, user, text }
    {:ok,
     assign(socket, posts: Enum.map(Posts.get_posts(), fn x -> convert_post_to_visual(x) end))}
  end

  defp convert_post_to_visual(post) do
    userinfo =
      case Auth.fetch_user(post.user_id) do
        {:ok, user} ->
          %{
            "id" => user.id,
            "name" =>
              if(user.display_name != nil and user.display_name != "",
                do: user.display_name,
                else: user.user_name
              )
          }

        {:error, _} ->
          %{"id" => nil, "name" => "Deleted User [#{post.user_id}]"}
      end

    %{
      "text" => post.text,
      "user" => userinfo,
      "date" => Timex.format!(post.inserted_at, "%d %h %Y %H:%M:%S", :strftime)
    }
  end

  @impl true
  def handle_event("create-post", %{"text" => text}, socket) do
    socket =
      case socket.assigns.user do
        nil ->
          socket

        user ->
          new_message = %{user_id: user.id, text: text}

          case Posts.create_post(new_message) do
            {:ok, post} ->
              visual_post = convert_post_to_visual(post)

              Hello2Web.Endpoint.broadcast_from(
                self(),
                @ps_channel,
                "create-post-notify",
                visual_post
              )

              assign(socket, posts: [visual_post] ++ socket.assigns.posts)

            {:error, _} ->
              socket
          end
      end

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "create-post-notify", payload: post, topic: @ps_channel}, socket) do
    {:noreply, assign(socket, posts: [post] ++ socket.assigns.posts)}
  end

  @impl true
  def render(assigns) do
    ~L"""

    <style>
      .posts-container {
        background: #f7f7f7;
      }
      .posts-container .post {
        display: flex;
      }
      .posts-container .post > * {
        margin-right: 24px;
      }
      .posts-container .post .date {
        font-style: italic;
      }
      .posts-container .post .user {
        font-weight: bold;
      }
    </style>

    <p>
      Signed in as user:
      <strong>
      <%=
        case @user do
          nil -> ""
          _ -> @user.user_name
        end
      %>
      </strong>
      <%= if @user == nil do %>
      [<a href="/signin">Sign in</a>]
      <% else %>
      [<a href="/signout">Sign out</a>]
      <% end %>
    </p>

    <%= if @user != nil do %>
    <form phx-submit="create-post">
        <label>Your message: <input type="text" name="text"></label>
        <input type="submit" value="Submit">
    </form>
    <% else %>
    <p>Please sign in to post messages.</p>
    <% end %>

    <div class="posts-container">
        <%= for post <- @posts do %>
          <div class="post">
            <div class="date">
              <%= post["date"] %>
            </div>
            <div class="user">
              <%= post["user"]["name"] %>
            </div>
            <div class="text">
              <%= post["text"] %>
            </div>
          </div>
        <% end %>
    </div>

    """
  end
end
