defmodule ElmBase.PageController do
  use ElmBase.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
