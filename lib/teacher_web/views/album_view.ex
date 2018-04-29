defmodule TeacherWeb.AlbumView do
  use TeacherWeb, :view

  def cents_to_dollars(price) do
    price / 100 |> Number.Currency.number_to_currency()
  end
end
