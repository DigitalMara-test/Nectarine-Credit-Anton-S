defmodule CredIt.OfferEmail do
  import Swoosh.Email

  def result(email, pdf_binary) do
    new()
    |> to(email)
    |> from({"CredIt", "noreply@cred-it.com"})
    |> subject("CredIt Offer")
    |> attachment(
      Swoosh.Attachment.new(
        {:data, pdf_binary},
        filename: "offer.pdf",
        content_type: "application/pdf"
      )
    )
  end
end
