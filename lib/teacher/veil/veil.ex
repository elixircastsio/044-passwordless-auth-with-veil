defmodule Teacher.Veil do
  @moduledoc """
  Veil's main context
  """
  alias Teacher.Repo
  alias Teacher.Veil.{User, Request, Session}
  alias TeacherWeb.Veil.{Mailer, LoginEmail}
  alias Veil.Secure

  # These are only used to sign request/session tokens that are saved in the database and
  # not sent to users.
  @request_salt "ink8S8TjVvDsrEwZNOwDXGBqHYoUL6QwLVOOSm+7ezkunQ=="
  @session_salt "Da7enKE5RxV9Hw8A7Yi1JzIx2pAeorqnqxzfsCOn/ndi1hU="

  @doc """
  Gets user associated with user_id
  """
  def get_user(user_id) do
    Repo.get(User, user_id)
  end

  @doc """
  Gets user associated with email
  """
  def get_user_by_email(email) do
    Repo.get_by(User, email: email |> String.downcase())
  end

  @doc """
  Creates an unverified user with the given email
  """
  def create_user(email) do
    %User{}
    |> User.changeset(%{email: email})
    |> Repo.insert()
  end

  @doc """
  Sets verified flag on the user associated with the user_id given, if needed
  """
  def verify_user(user_id) do
    if user = get_user(user_id) do
      unless user.verified do
        user
        |> User.changeset(%{verified: true})
        |> Repo.update()
      end
    end
  end

  @doc """
  Sends a new login email to the user
  """
  def send_login_email(conn, %User{} = user, %Request{} = request) do
    user.email
    |> LoginEmail.generate(new_session_url(conn, request.unique_id))
    |> Mailer.deliver()
  end

  defp new_session_url(conn, unique_id) do
    cur_uri = Phoenix.Controller.endpoint_module(conn).struct_url()
    cur_path = TeacherWeb.Router.Helpers.session_path(conn, :create, unique_id)
    TeacherWeb.Router.Helpers.url(cur_uri) <> cur_path
  end

  @doc """
  Creates a new login request for the user provided
  """
  def create_request(conn, %User{} = user) do
    phoenix_token = Phoenix.Token.sign(conn, @request_salt, user.id)
    unique_id = Secure.generate_unique_id(conn)

    %Request{}
    |> Request.changeset(%{
      user_id: user.id,
      phoenix_token: phoenix_token,
      unique_id: unique_id,
      ip_address: Secure.get_user_ip(conn)
    })
    |> Repo.insert()
  end

  @doc """
  Gets the request associated with the unique id
  """
  def get_request(unique_id) do
    if request = Repo.get_by(Request, unique_id: unique_id) do
      {:ok, request}
    else
      {:error, :no_permission}
    end
  end

  @doc """
  Verifies that the phoenix_token inside the request/session is valid and has not expired
  """
  def verify(%Session{} = session) do
    verify(TeacherWeb.Endpoint, session)
  end

  def verify(%Request{} = request) do
    verify(TeacherWeb.Endpoint, request)
  end

  def verify(conn, %Session{phoenix_token: phoenix_token}) do
    max_age = Application.get_env(:veil, :session_expiry)
    verify_session_token(conn, phoenix_token, max_age)
  end

  def verify(conn, %Request{phoenix_token: phoenix_token}) do
    max_age = Application.get_env(:veil, :sign_in_link_expiry)
    Phoenix.Token.verify(conn, @request_salt, phoenix_token, max_age: max_age)
  end

  @doc """
  Creates a new session for the user associated with user_id
  """
  def create_session(conn, user_id) do
    %Session{}
    |> Session.changeset(%{
      user_id: user_id,
      phoenix_token: create_session_token(conn, user_id),
      unique_id: Secure.generate_unique_id(conn),
      ip_address: Secure.get_user_ip(conn)
    })
    |> Repo.insert()
  end

  defp create_session_token(conn, user_id) do
    Phoenix.Token.sign(conn, @session_salt, user_id)
  end

  @doc """
  Gets the session associated with the unique id
  """
  def get_session(nil), do: {:error, :no_permission}

  def get_session(unique_id) do
    if session = Repo.get_by(Session, unique_id: unique_id) do
      {:ok, session}
    else
      {:error, :no_permission}
    end
  end

  @doc """
  Extends the session if it is older than the refresh_expiry_interval, by signing a new
  phoenix_token and replacing the one in the database
  """
  def extend_session(conn, %Session{phoenix_token: phoenix_token, user_id: user_id} = session) do
    max_age = Application.get_env(:veil, :refresh_expiry_interval)

    case verify_session_token(conn, phoenix_token, max_age) do
      {:error, :expired} ->
        session
        |> Session.changeset(%{phoenix_token: create_session_token(conn, user_id)})
        |> Repo.update()

      _ ->
        nil
    end
  end

  defp verify_session_token(conn, phoenix_token, max_age) do
    Phoenix.Token.verify(conn, @session_salt, phoenix_token, max_age: max_age)
  end

  @doc """
  Deletes the request/session
  """
  def delete(%Session{} = session) do
    Repo.delete(session)
  end

  def delete(%Request{} = request) do
    Repo.delete(request)
  end

  @doc """
  Deletes the session by unique id
  """
  def delete_session(unique_id) do
    with {:ok, session} <- get_session(unique_id) do
      delete(session)
    else
      error -> error
    end
  end

  def delete_expired(list) when is_list(list) do
    list
    |> Enum.each(fn event ->
      case verify(event) do
        {:error, _} ->
          delete(event)

        {:ok, _} ->
          nil
      end
    end)
  end

  @doc """
  Deletes all expired requests
  """
  def delete_expired_requests do
    Request
    |> Repo.all()
    |> delete_expired()
  end

  @doc """
  Deletes all expired sessions
  """
  def delete_expired_sessions do
    Session
    |> Repo.all()
    |> delete_expired()
  end
end
