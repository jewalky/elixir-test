defmodule Hello2Web.PageTest do
  use Hello2Web, :live_view

  # IO.inspect()

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, select_value: "<unset>")}
  end

  @impl true
  def handle_event("change", %{"test_select" => val} = everything, socket) do
    IO.inspect(everything)
    {:noreply, assign(socket, select_value: val)}
  end

  def render(assigns) do
    ~L"""

    <p>Hello!</p>

    <form phx-change="change">
      <select name="test_select">
        <option value="test1" <%= if @select_value == "test1", do: "selected" %>>Test 1</option>
        <option value="test2" <%= if @select_value == "test2", do: "selected" %>>Test 2</option>
        <option value="<unset>" <%= if @select_value == "<unset>", do: "selected" %>>Unset</option>
      </select>
    </form>

    <p>Current value: <%= @select_value %></p>

    """
  end
end
