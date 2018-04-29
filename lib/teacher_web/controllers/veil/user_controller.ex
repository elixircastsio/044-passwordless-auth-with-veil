defmodule TeacherWeb.Veil.UserController do
  use TeacherWeb, :controller
  alias Teacher.Veil
  alias Teacher.Veil.User

  action_fallback(TeacherWeb.Veil.FallbackController)

  
  plug(:scrub_params, "user" when action in [:create])

  @doc """
  Shows the sign in form
  """
  def new(conn, _params) do
    render(conn, "new.html", changeset: User.changeset(%User{}))
  end
  

  @doc """
  If needed, creates a new user, otherwise finds the existing one.
  Creates a new request and emails the unique id to the user.
  """
  
  def create(conn, %{"user" => %{"email" => email}}) when not is_nil(email) do
  
    if user = Veil.get_user_by_email(email) do
      sign_and_email(conn, user)
    else
      with {:ok, user} <- Veil.create_user(email) do
        sign_and_email(conn, user)
      else
        error ->
          error
      end
    end
  end

  defp sign_and_email(conn, %User{} = user) do
    with {:ok, request} <- Veil.create_request(conn, user),
         {:ok, email} <- Veil.send_login_email(conn, user, request) do
      
        render(conn, "show.html", user: user, email: email)
      
    else
      error ->
        error
    end
  end
end
