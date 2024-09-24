defmodule GalleryWeb.Router do
  use GalleryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GalleryWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GalleryWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/atom.xml", AtomController, :index
    get "/:year/:month/:name", GalleryController, :gallery
  end

  # Other scopes may use custom stacks.
  # scope "/api", GalleryWeb do
  #   pipe_through :api
  # end
end
