defmodule FpMatsuri2025.LedSupervisor do
  use Supervisor

  def start_link(args) do
    name = Keyword.get(args, :name, __MODULE__)
    Supervisor.start_link(__MODULE__, args, name: name)
  end

  def init(_args) do
    children = [
      led_child_spec(name: FpMatsuri2025.Led1, red_pin: "GPIO17", green_pin: "GPIO27"),
      led_child_spec(name: FpMatsuri2025.Led2, red_pin: "GPIO22", green_pin: "GPIO5"),
      led_child_spec(name: FpMatsuri2025.Led3, red_pin: "GPIO23", green_pin: "GPIO24"),
      led_child_spec(name: FpMatsuri2025.Led4, red_pin: "GPIO25", green_pin: "GPIO16")
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def flush_leds() do
    leds = [
      FpMatsuri2025.Led1,
      FpMatsuri2025.Led2,
      FpMatsuri2025.Led3,
      FpMatsuri2025.Led4
    ]

    :ok =
      leds
      |> Enum.each(fn name ->
        FpMatsuri2025.Led.red(name)
        Process.sleep(100)
      end)

    :ok =
      Enum.reverse(leds)
      |> Enum.each(fn name ->
        FpMatsuri2025.Led.green(name)
        Process.sleep(100)
      end)

    :ok =
      leds
      |> Enum.each(fn name ->
        FpMatsuri2025.Led.off(name)
        Process.sleep(100)
      end)
  end

  defp led_child_spec(args) do
    name = Keyword.fetch!(args, :name)
    Supervisor.child_spec({FpMatsuri2025.Led, args}, id: name)
  end
end
