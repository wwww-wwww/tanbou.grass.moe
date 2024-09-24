defmodule GalleryWeb.GalleryController do
  use GalleryWeb, :controller

  def gallery(conn, %{"year" => year, "month" => month, "name" => name}) do
    str =
      Phoenix.Template.render(GalleryWeb.GalleryHTML, "#{year}-#{month}-#{name}", "html",
        index: false
      )
      |> Phoenix.HTML.html_escape()
      |> Phoenix.HTML.safe_to_string()

    title =
      Regex.run(~r/.*<h1>(.+?)<\/h1>.*/s, str)
      |> Enum.at(1)
      |> String.trim()

    conn
    |> put_layout(html: :gallery)
    |> assign(:page_title, title)
    |> assign(:page, "#{year}-#{month}-#{name}")
    |> assign(:index, false)
    |> render("#{year}-#{month}-#{name}.html")
  end
end
