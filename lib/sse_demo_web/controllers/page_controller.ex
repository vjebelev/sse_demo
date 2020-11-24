defmodule SseDemoWeb.PageController do
  use SseDemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
