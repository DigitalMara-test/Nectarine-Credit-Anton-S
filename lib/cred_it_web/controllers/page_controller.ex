defmodule CredItWeb.PageController do
  use CredItWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def done(conn, _params) do
    render(conn, :done)
  end
end
