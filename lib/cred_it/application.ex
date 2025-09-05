defmodule CredIt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CredItWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:cred_it, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CredIt.PubSub},
      # Start a worker by calling: CredIt.Worker.start_link(arg)
      # {CredIt.Worker, arg},
      # Start to serve requests, typically the last entry
      CredItWeb.Endpoint,
      {ChromicPDF, chromic_pdf_opts()},
      {Task.Supervisor, name: CredIt.OfferMailerSupervisor},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CredIt.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CredItWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  @chromic_pdf_opts Application.compile_env!(:cred_it, ChromicPDF)
  defp chromic_pdf_opts do
    @chromic_pdf_opts ++ [
      # discard_stderr: false, # debug mode
      no_sandbox: true, # Running as root without --no-sandbox is not supported. See https://crbug.com/638180.
    ]
  end
end
