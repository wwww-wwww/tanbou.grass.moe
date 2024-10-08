defmodule GalleryWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use GalleryWeb, :html

  embed_templates "page/*"
end
