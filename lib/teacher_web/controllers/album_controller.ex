defmodule TeacherWeb.AlbumController do
  use TeacherWeb, :controller

  alias Teacher.Records
  alias Teacher.Records.Album

  plug TeacherWeb.Plugs.Veil.Authenticate when action not in [:show, :index]

  def index(conn, _params) do
    albums = Records.list_albums()
    render(conn, "index.html", albums: albums)
  end

  def new(conn, _params) do
    changeset = Records.change_album(%Album{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"album" => album_params}) do
    case Records.create_album(album_params) do
      {:ok, album} ->
        conn
        |> put_flash(:info, "Album created successfully.")
        |> redirect(to: album_path(conn, :show, album))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    album = Records.get_album!(id)
    render(conn, "show.html", album: album)
  end

  def edit(conn, %{"id" => id}) do
    album = Records.get_album!(id)
    changeset = Records.change_album(album)
    render(conn, "edit.html", album: album, changeset: changeset)
  end

  def update(conn, %{"id" => id, "album" => album_params}) do
    album = Records.get_album!(id)

    case Records.update_album(album, album_params) do
      {:ok, album} ->
        conn
        |> put_flash(:info, "Album updated successfully.")
        |> redirect(to: album_path(conn, :show, album))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", album: album, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    album = Records.get_album!(id)
    {:ok, _album} = Records.delete_album(album)

    conn
    |> put_flash(:info, "Album deleted successfully.")
    |> redirect(to: album_path(conn, :index))
  end
end
