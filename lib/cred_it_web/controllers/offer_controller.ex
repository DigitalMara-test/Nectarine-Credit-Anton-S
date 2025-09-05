defmodule CredItWeb.OfferController do
  use CredItWeb, :controller
  alias CredIt.Credit
  alias CredIt.Credit.{Contact, Offer}

  def new(conn, _params) do
    changeset = Credit.change_offer(%Offer{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"offer" => offer_params}) do
    changeset = Credit.change_offer(%Offer{}, offer_params)

    case changeset.valid? do
      true ->
        offer = Ecto.Changeset.apply_changes(changeset)
        credit_limit = Credit.calculate_credit_limit(offer)

        conn
        |> put_session(:offer, offer)
        |> put_session(:credit_limit, credit_limit)
        |> put_flash(:info, "Congratulations, you have been approved for credit up to $#{credit_limit} USD")
        |> redirect(to: ~p"/offer/result")

      false ->
        conn
        |> put_flash(:error, "Something went wrong. Please try again.")
        |> redirect(to: ~p"/offer/new")
    end
  end

  def result(conn, _params) do
    credit_limit = get_session(conn, :credit_limit)
    changeset = Credit.change_contact(%Contact{})

    render(conn, :result,
      credit_limit: credit_limit,
      changeset: changeset
    )
  end

  def send(conn, %{"contact" => contact_params}) do
    changeset = Credit.change_contact(%Contact{}, contact_params)

    case changeset.valid? do
      true ->
        contact = Ecto.Changeset.apply_changes(changeset)
        email = Map.get(contact, :email)

        credit_limit = get_session(conn, :credit_limit)
        offer = get_session(conn, :offer)
        survey = get_session(conn, :survey)
        score = get_session(conn, :score)

        content = CredItWeb.OfferPDF.offer(%{
          credit_limit: credit_limit,
          survey: survey,
          score: score,
          offer: offer
        }) |> Phoenix.HTML.Safe.to_iodata()

        Credit.send_offer(email, content)

        conn
        |> clear_session()
        |> put_flash(:info, "Please check your email for the detailed offer")
        |> redirect(to: ~p"/done")

      false ->
        conn
        |> put_flash(:error, "Something went wrong. Please try again.")
        |> redirect(to: ~p"/offer/result")
    end
  end
end
