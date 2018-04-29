defmodule Teacher.Records.Album do
  use Ecto.Schema
  import Ecto.Changeset
  alias Teacher.Records.Album


  schema "albums" do
    field :artist, :string
    field :summary, :string
    field :title, :string
    field :year, :string
    field :price, :integer

    timestamps()
  end

  @doc false
  def changeset(%Album{} = album, attrs) do
    album
    |> cast(attrs, [:artist, :title, :summary, :year, :price])
    |> validate_required([:artist, :title, :summary, :year, :price])
  end
end
