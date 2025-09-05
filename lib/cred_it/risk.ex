defmodule CredIt.Risk do
  @moduledoc """
  The Risk context.
  """

  alias CredIt.Risk.Survey

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking survey changes.

  ## Examples

      iex> change_survey(survey)
      %Ecto.Changeset{data: %Survey{}}

  """
  def change_survey(%Survey{} = survey, attrs \\ %{}) do
    Survey.changeset(survey, attrs)
  end

  @weights [
    has_job_now: 4,
    has_job_year: 2,
    has_home: 2,
    has_car: 1,
    has_side_income: 2
  ]

  def calculate_score(%Survey{} = survey) do
    @weights
    |> Enum.filter(fn {key, _value} -> Map.get(survey, key) end)
    |> Enum.map(fn {_key, value} -> value end)
    |> Enum.sum()
  end

  @doc """
  Determines if the user qualifies for credit based on their score.
  Returns true if score > 6, false otherwise.

  ## Examples

      iex> qualifies_for_credit?(7)
      true

      iex> qualifies_for_credit?(6)
      false

  """
  def qualifies_for_credit?(score) when is_integer(score) do
    score > 6
  end
end
