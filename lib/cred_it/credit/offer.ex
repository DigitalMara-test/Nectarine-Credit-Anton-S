defmodule CredIt.Credit.Offer do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key false

  embedded_schema do
    field :monthly_income, :decimal
    field :monthly_expenses, :decimal
  end

  @doc false
  def changeset(offer, attrs) do
    offer
    |> cast(attrs, [:monthly_income, :monthly_expenses])
    |> validate_required([:monthly_income, :monthly_expenses])
    |> validate_number(:monthly_income, greater_than: 0)
    |> validate_number(:monthly_expenses, greater_than: 0)
    |> validate_diff()
  end

  defp validate_diff(changeset) do
    if get_field(changeset, :monthly_income) < get_field(changeset, :monthly_expenses) do
      add_error(changeset, :monthly_income, "Monthly income must be greater than monthly expenses")
    else
      changeset
    end
  end
end
