defmodule GalleryWeb.BuildTest do
  use GalleryWeb.ConnCase, async: true

  @outdir "out"

  def generate_html_for_route(conn, route_path) do
    File.cp_r("priv/static", @outdir)

    resp =
      get(conn, route_path)
      |> response(200)
      |> String.split(~r/\n/, trim: true)
      |> Enum.join("\n")

    priv_static_path = Path.join(@outdir, route_path)

    assert File.mkdir_p(priv_static_path) == :ok

    {:ok, file} =
      priv_static_path
      |> Path.join("index.html")
      |> File.open([:write])

    assert IO.binwrite(file, resp) == :ok
    File.close(file)
  end

  test "GET /", %{conn: conn} do
    galleries =
      GalleryWeb.galleries()
      |> Enum.map(&String.split(&1, "-"))
      |> Enum.map(&"#{Enum.at(&1, 0)}/#{Enum.at(&1, 1)}/#{Enum.join(Enum.drop(&1, 2), "-")}")

    (["/", "/atom.xml"] ++ galleries)
    |> Enum.each(&generate_html_for_route(conn, &1))
  end
end
