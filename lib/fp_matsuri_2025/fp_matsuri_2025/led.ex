defmodule FpMatsuri2025.Led do
  use GenServer

  def red(name), do: GenServer.call(name, :red)
  def green(name), do: GenServer.call(name, :green)
  def orange(name), do: GenServer.call(name, :orange)
  def off(name), do: GenServer.call(name, :off)

  def start_link(args) do
    name = Keyword.get(args, :name, __MODULE__)
    GenServer.start_link(__MODULE__, args, name: name)
  end

  def init(args) do
    name = Keyword.fetch!(args, :name)

    red_pin = Keyword.fetch!(args, :red_pin)
    green_pin = Keyword.fetch!(args, :green_pin)

    {:ok,
     %{
       name: name,
       red_pin: red_pin,
       green_pin: green_pin
     }}
  end

  def handle_call(:red, _from, state) do
    Circuits.GPIO.write_one(state.green_pin, 0)
    Circuits.GPIO.write_one(state.red_pin, 1)
    {:reply, :ok, state}
  end

  def handle_call(:green, _from, state) do
    Circuits.GPIO.write_one(state.red_pin, 0)
    Circuits.GPIO.write_one(state.green_pin, 1)
    {:reply, :ok, state}
  end

  def handle_call(:orange, _from, state) do
    Circuits.GPIO.write_one(state.red_pin, 1)
    Circuits.GPIO.write_one(state.green_pin, 1)
    {:reply, :ok, state}
  end

  def handle_call(:off, _from, state) do
    Circuits.GPIO.write_one(state.red_pin, 0)
    Circuits.GPIO.write_one(state.green_pin, 0)
    {:reply, :ok, state}
  end
end
