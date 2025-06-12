defmodule FpMatsuri2025Web.Live.Home do
  use FpMatsuri2025Web, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end

  def handle_event("flush-leds", _value, socket) do
    spawn(FpMatsuri2025.LedSupervisor, :flush_leds, [])
    {:noreply, socket}
  end
end
