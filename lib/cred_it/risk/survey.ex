defmodule CredIt.Risk.Survey do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key false

  embedded_schema do
    field :has_job_now, :boolean, default: false
    field :has_job_year, :boolean, default: false
    field :has_home, :boolean, default: false
    field :has_car, :boolean, default: false
    field :has_side_income, :boolean, default: false
  end

  @doc false
  def changeset(survey, attrs) do
    survey
    |> cast(attrs, [:has_job_now, :has_job_year, :has_home, :has_car, :has_side_income])
    |> validate_required([:has_job_now, :has_job_year, :has_home, :has_car, :has_side_income])
  end
end
