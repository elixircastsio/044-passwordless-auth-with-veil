defmodule TeacherWeb.Veil.SessionController do
  use TeacherWeb, :controller
  alias Teacher.Veil

  action_fallback(TeacherWeb.Veil.FallbackController)

  @doc """
  Creates a new session using a unique id sent by email.
  If creating the new session is successful, the user is verified and the request is deleted.
  """
  def create(conn, %{"request_id" => request_unique_id}) do
    with {:ok, request} <- Veil.get_request(request_unique_id),
         {:ok, user_id} <- Veil.verify(conn, request),
         {:ok, session} <- Veil.create_session(conn, user_id) do
      Task.start(fn -> Veil.verify_user(user_id) end)
      Task.start(fn -> Veil.delete(request) end)

      conn
      |> put_resp_cookie("session_unique_id", session.unique_id, max_age: 60*60*24*365)
      |> redirect(to: album_path(conn, :index))
    else
      error ->
        error
    end
  end

  @doc """
  Deletes an existing session and logs the user out.
  """
  def delete(conn, %{"session_id" => session_unique_id}) do
    with {:ok, _session} <- Veil.delete_session(session_unique_id) do

      conn
      |> delete_resp_cookie("session_unique_id", max_age: 60*60*24*365)
      |> redirect(to: user_path(conn, :new))

    else
      error ->
        error
    end
  end
end
