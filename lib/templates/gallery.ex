defmodule GalleryWeb.GalleryHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use GalleryWeb, :html

  embed_templates "gallery/*"

  def title(assigns) do
    {year, month, name_e} =
      if assigns.assigns.index do
        assigns.assigns.page
      else
        {"", "", ""}
      end

    assigns =
      assigns
      |> assign(
        :url,
        GalleryWeb.Router.Helpers.gallery_path(
          GalleryWeb.Endpoint,
          :gallery,
          year,
          month,
          name_e
        )
      )

    ~H"""
    <h1>
      <%= if @assigns.index do %>
        <a href={@url}>
          <%= render_slot(@inner_block) %>
        </a>
      <% else %>
        <%= render_slot(@inner_block) %>
      <% end %>
    </h1>
    """
  end

  def collection(assigns) do
    urls =
      ~H"""
      <%= render_slot(@inner_block) %>
      """
      |> Phoenix.HTML.html_escape()
      |> Phoenix.HTML.safe_to_string()
      |> String.split("\n")
      |> Enum.filter(&(String.length(&1) > 0))
      |> Enum.map(&{&1, String.replace(&1, "2024-05-mygo/", "2024-05-mygo/thumb/")})

    assigns = assign(assigns, :urls, urls)

    ~H"""
    <div class="collection">
      <div>
        <%= for {url, thumb} <- @urls do %>
          <div><img src={thumb} fullsize={url} loading="lazy" /></div>
        <% end %>
      </div>
    </div>
    """
  end

  def sa(assigns) do
    ~H"""
    <p><a href={@href}><%= @href %></a></p>
    """
  end

  def date(assigns) do
    if Map.get(assigns.assigns, :text, false) do
      ~H"""
      <span class="date"><%= render_slot(@inner_block) %></span>
      """
    else
      {:ok, time, _} =
        ~H"""
        <%= render_slot(@inner_block) %>
        """
        |> Phoenix.HTML.html_escape()
        |> Phoenix.HTML.safe_to_string()
        |> DateTime.from_iso8601()

      assigns = assign(assigns, :time, Calendar.strftime(time, "%B %d, %Y"))

      ~H"""
      <span class="date"><%= @time %></span>
      """
    end
  end

  def short(assigns) do
    if assigns.assigns.index do
      ~H"""
      <%= render_slot(@inner_block) %>
      """
    else
      ~H""
    end
  end

  def full(assigns) do
    if assigns.assigns.index do
      ~H""
    else
      ~H"""
      <%= render_slot(@inner_block) %>
      """
    end
  end
end
