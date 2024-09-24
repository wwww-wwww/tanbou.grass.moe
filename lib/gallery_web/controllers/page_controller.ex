defmodule GalleryWeb.PageController do
  use GalleryWeb, :controller

  def index(conn, _params) do
    # {_, _, templates} = GalleryWeb.GalleryView.__templates__()

    templates =
      GalleryWeb.galleries()
      |> Enum.map(fn filename ->
        split = String.split(filename, "-")

        year = Enum.at(split, 0)
        month = Enum.at(split, 1)
        rest = Enum.drop(split, 2)

        {year, month, Enum.join(rest, " "), Enum.join(rest, "-"), filename}
      end)

    render(conn, :index, galleries: templates)
  end

  def page(%{request_path: "/" <> page} = conn, _params) do
    conn
    # |> assign(:page_title, title(page))
    |> render(String.to_atom(page))
  end
end
