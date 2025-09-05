defmodule CredItWeb.OfferHTML do
  use CredItWeb, :html

  embed_templates "offer_html/*"

  @doc """
  Renders a offer form.

  The form is defined in the template at
  offer_html/offer_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def offer_form(assigns)

  @doc """
  Renders a contact form.

  The form is defined in the template at
  offer_html/contact_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def contact_form(assigns)
end
