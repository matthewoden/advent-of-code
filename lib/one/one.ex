defmodule One do
  require Logger

  def main do
    File.read!("./lib/one/data/input.txt")
    |> String.split(",")
    |> Enum.map(&split_step/1)
    |> Traversal.plot_route()
    |> calculate_distance()
    |> print_output
  end

  def split_step(step) do
    step
    |> String.trim()
    |> String.split_at(1)
    |> convert_to_int
  end

  def convert_to_int ({ direction, int_string }) do
     { direction, String.to_integer(int_string) }
  end

  def calculate_distance(state), do: abs(state.x) + abs(state.y)

  def print_output(blocks), do: IO.puts "#{blocks} blocks from the start."

end

One.main()
