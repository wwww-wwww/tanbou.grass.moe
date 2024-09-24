defmodule GalleryWeb.AtomController do
  use GalleryWeb, :controller

  alias Atomex.{Feed, Entry}

  @author "w"

  def index(conn, _params) do
    entries =
      GalleryWeb.galleries()
      |> Enum.map(fn filename ->
        split =
          String.split(filename, ".")
          |> Enum.at(0)
          |> String.split("-")

        year = Enum.at(split, 0)
        month = Enum.at(split, 1)
        rest = Enum.drop(split, 2)
        name = Enum.join(rest, "-")

        str =
          Phoenix.Template.render(
            GalleryWeb.GalleryHTML,
            filename,
            "html",
            index: false,
            text: true
          )
          |> Phoenix.HTML.html_escape()
          |> Phoenix.HTML.safe_to_string()

        {:ok, date, _} =
          Regex.run(~r/.*<span class="date">(.+?)<\/span>.*/s, str)
          |> Enum.at(1)
          |> String.trim()
          |> DateTime.from_iso8601()

        title =
          Regex.run(~r/.*<h1>(.+?)<\/h1>.*/s, str)
          |> Enum.at(1)
          |> String.trim()

        Entry.new(String.split(filename, ".") |> Enum.at(0), date, title)
        |> Entry.link(GalleryWeb.Router.Helpers.gallery_url(conn, :gallery, year, month, name))
        |> Entry.author(@author)
        # |> Entry.content("summary", type: "text")
        |> Entry.build()
      end)

    feed =
      Feed.new(
        GalleryWeb.Router.Helpers.page_url(conn, :index),
        DateTime.utc_now(),
        "w's Exploration"
      )
      |> Feed.author(@author)
      |> Feed.link(GalleryWeb.Router.Helpers.atom_url(conn, :index), rel: "self")
      |> Feed.entries(entries)
      |> Feed.build()
      |> Atomex.generate_document()

    conn
    |> put_resp_content_type("text/xml")
    |> send_resp(200, feed)
  end
end
