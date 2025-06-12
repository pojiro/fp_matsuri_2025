defmodule FpMatsuri2025.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        # Children for all targets
        # Starts a worker by calling: FpMatsuri2025.Worker.start_link(arg)
        # {FpMatsuri2025.Worker, arg},
      ] ++ target_children() ++ phoenix_children()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FpMatsuri2025.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, new, removed) do
    phoenix_config_change(changed, new, removed)
    :ok
  end

  # List all child processes to be supervised
  if Mix.target() == :host do
    defp target_children() do
      [
        # Children that only run on the host during development or test.
        # In general, prefer using `config/host.exs` for differences.
        #
        # Starts a worker by calling: Host.Worker.start_link(arg)
        # {Host.Worker, arg},
      ]
    end
  else
    defp target_children() do
      # NOTE: work around to stop watchers on targets
      Application.get_env(:fp_matsuri_2025, FpMatsuri2025Web.Endpoint)
      |> Keyword.put(:watchers, [])
      |> then(&Application.put_env(:fp_matsuri_2025, FpMatsuri2025Web.Endpoint, &1))

      [
        # Children for all targets except host
        # Starts a worker by calling: Target.Worker.start_link(arg)
        # {Target.Worker, arg},
        {FpMatsuri2025.LedSupervisor, []}
      ]
    end
  end

  defp phoenix_children() do
    [
      FpMatsuri2025Web.Telemetry,
      {DNSCluster, query: Application.get_env(:fp_matsuri_2025, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FpMatsuri2025.PubSub},
      # Start a worker by calling: FpMatsuri2025.Worker.start_link(arg)
      # {FpMatsuri2025.Worker, arg},
      # Start to serve requests, typically the last entry
      FpMatsuri2025Web.Endpoint
    ]
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  defp phoenix_config_change(changed, _new, removed) do
    FpMatsuri2025Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
