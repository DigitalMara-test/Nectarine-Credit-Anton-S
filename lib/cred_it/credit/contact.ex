defmodule CredIt.Credit.Contact do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key false

  embedded_schema do
    field :email, :string
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
  end
end
