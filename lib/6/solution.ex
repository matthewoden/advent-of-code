defmodule DaySix.Solution do
  def part_one(stream) do
    handle_stream(stream)
    |> Enum.map(fn item -> item.max end)
    |> Enum.join
  end

  def part_two(stream) do
    handle_stream(stream)
    |> Enum.map(fn item -> item.min end)
    |> Enum.join
  end

  def handle_stream(stream) do
    stream
    |> Enum.map(&handle_line(&1))
    |> Enum.reduce(%{}, fn (line, map) -> accumulate(map, line) end)
    |> IO.inspect
    |> Map.values()
  end

  def handle_line(line) do
    line
    |> String.replace("\n", "")
    |> String.split("", trim: true)
    |> map_letters(0, [])
  end

  def map_letters([], _, state), do: Enum.reverse state
  def map_letters([ letter | tail ], position, state) do
    map_letters(tail, position + 1, [{ position, letter } | state ])
  end

  def accumulate(map, []), do: map
  def accumulate(map, [{ position, letter} | rest ]) do
    initial_state = %{ letter => 1, max: letter, min: letter }
    Map.update(map, position, initial_state, &update_position(&1, letter))
    |> accumulate(rest)
  end

  def update_position(state, letter) do
    state
    |> Map.update(letter, 1, &(&1 + 1))
    |> save_highest(letter)
    |> save_lowest(letter)

  end

  def save_highest(state, letter) do
    highest = Map.get(state, state.max, 0)
    case state[letter] > highest do
      true -> Map.put(state, :max, letter)
      false -> state
    end
  end

  def save_lowest(state, letter) do
    [ { lowest, lowest_value } | rest ] =
      state
      |> Map.drop([:min, :max])
      |> Map.to_list()
      |> Enum.sort(fn {_k1, a1}, {_k2, a2} -> a1 < a2 end)


    Map.put(state, :min, lowest)
  end

end

# File.stream!("./lib/6/data/input.txt")
# |> DaySix.Solution.part_one
# |> IO.inspect

File.stream!("./lib/6/data/input.txt")
|> DaySix.Solution.part_two
|> IO.inspect
