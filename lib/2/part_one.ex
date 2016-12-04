defmodule DayTwoPartOne do
  def main do
    File.read!("./lib/2/data/input.txt")
    |> format_input
    |> traverse
    |> format_output
  end

  @keypad [
    [1,2,3],
    [4,5,6],
    [7,8,9]
  ]


  @initial_state %{ x: 1, y: 1, key: [] }

  def format_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn (line) -> String.trim(line) |> String.to_charlist end)
  end

  def traverse(lines), do: traverse_line(@initial_state, lines)
  def traverse_line(state, []), do: state
  def traverse_line(state, [ directions | remaining_lines] ) do
    state
    |> route_path(directions)
    |> get_keypad_value
    |> traverse_line(remaining_lines)
  end

  def format_output(state) do
    IO.puts "Day 2, Part 1: #{state.key |> Enum.reverse |> Enum.join}"
  end

  def route_path(state, []), do: state
  def route_path(state, [ current | remaining_steps ] ) do
    state
    |> move(current)
    |> route_path(remaining_steps)
  end

  def move(state, direction) do
    case direction do
      ?U -> decrement(state, :y)
      ?D -> increment(state, :y)

      ?R -> increment(state, :x)
      ?L -> decrement(state, :x)
    end
  end

  def increment(state, atom) do
    value = Map.get(state, atom) + 1
    if value < 3 do
      Map.put(state, atom, value )
    else
      state
    end
  end

  def decrement(state, atom) do
    value = Map.get(state, atom) - 1
    if value > -1 do
      Map.put(state, atom, value )
    else
      state
    end
  end

  def get_keypad_value(state) do
    key = @keypad
          |> Enum.at(state.y)
          |> Enum.at(state.x)

    %{ state | :key => [key | state.key] }
  end
end
