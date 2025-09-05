defmodule CredIt.Credit do
  @moduledoc """
  The Credit context.
  """

  alias CredIt.Credit.{Contact, Offer}

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking offer changes.

  ## Examples

      iex> change_offer(offer)
      %Ecto.Changeset{data: %Offer{}}

  """
  def change_offer(%Offer{} = offer, attrs \\ %{}) do
    Offer.changeset(offer, attrs)
  end

  def change_contact(%Contact{} = contact, attrs \\ %{}) do
    Contact.changeset(contact, attrs)
  end

  def calculate_credit_limit(%{monthly_income: monthly_income, monthly_expenses: monthly_expenses}) do
    factor = Decimal.new("12")

    monthly_income
    |> Decimal.sub(monthly_expenses)
    |> Decimal.mult(factor)
  end

  def send_offer(email, content) do
    Task.Supervisor.start_child(CredIt.OfferMailerSupervisor, fn ->
      [
        content: content,
        size: :a4
      ]
      |> ChromicPDF.Template.source_and_options()
      |> ChromicPDF.print_to_pdf(output: fn pdf ->
        CredIt.OfferEmail.result(email, File.read!(pdf))
        |> CredIt.Mailer.deliver()
      end)
    end)
  end
end
