defmodule CredItWeb.SurveyController do
  use CredItWeb, :controller
  alias CredIt.Risk
  alias CredIt.Risk.Survey

  def new(conn, _params) do
    changeset = Risk.change_survey(%Survey{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"survey" => survey_params}) do
    changeset = Risk.change_survey(%Survey{}, survey_params)

    case changeset.valid? do
      true ->
        survey = Ecto.Changeset.apply_changes(changeset)
        score = Risk.calculate_score(survey)

        if Risk.qualifies_for_credit?(score) do
          conn
          |> put_session(:survey, survey)
          |> put_session(:score, score)
          |> put_flash(:info, "Congratulations! You qualify for credit. Your score: #{score}")
          |> redirect(to: ~p"/offer/new")
        else
          conn
          |> put_flash(:error, "Thank you for your answer. We are currently unable to issue credit to you. Your score: #{score}")
          |> redirect(to: ~p"/survey/decline")
        end

      false ->
        conn
        |> put_flash(:error, "Something went wrong. Please try again.")
        |> redirect(to: ~p"/survey/new")
    end
  end

  def decline(conn, _params) do
    render(conn, :decline)
  end
end
