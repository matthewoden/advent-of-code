defmodule DayFour.Solution do

  def part_one(line) do
    line
    |> Enum.map(&Task.async(fn -> process_line(&1) end))
    |> Enum.map(&Task.await(&1))
    |> Enum.filter(&validate(&1))
  end

  def part_two(line) do
    line
    |> Enum.map(&Task.async(fn -> process_line(&1) end))
    |> Enum.map(&Task.await(&1))
    |> Enum.filter(fn item -> decrypt(item) == "northpole object storage" end)
    |> IO.inspect
  end

  def process_line(line) do
    regex = ~r/(?<name>.*)-(?<sector_id>\d+)\[(?<checksum>\w+)\]/
    captures = Regex.named_captures(regex, line)

    %{ name: captures["name"],
       letters: letter_map(captures["name"]),
       checksum: captures["checksum"],
       sector_id: String.to_integer captures["sector_id"]
     }
  end

  def letter_map(string) do
    string
    |> String.split(~r//, trim: true)
    |> Enum.reduce(%{}, &inc/2)
  end

  def inc("-", state), do: state
  def inc(x, state), do: Map.update(state, x, 1, &(&1 + 1))

  def validate(state) do
    value = state.letters
            |> Map.to_list
            |> Enum.sort(&sort(&1, &2))
            |> Enum.map(fn { k, _v } -> k end)
            |> Enum.take(5)
            |> Enum.join()

    value == state.checksum
  end

  def sort({k1, v1}, {k2, v2}), do: if v1 == v2, do: k1 < k2, else: v1 > v2


  def decrypt(room) do
    room.name
      |> to_charlist
      |> Enum.map(fn(c) -> rotate(c, room.sector_id) end)
      |> to_string
  end

  @alphabet 'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz'

  def rotate(?-, _), do: 32

  def rotate(c, shift) do
    index = Enum.find_index(@alphabet, fn(a) -> a == c end)
    new_index = index + rem(shift, 26)
    Enum.at(@alphabet, new_index)
  end

end

# File.stream!("./lib/4/data/input.txt")
# |> DayFour.Solution.part_one()
# |> Enum.map(fn item -> item.sector_id end)
# |> Enum.sum()
#
# File.stream!("./lib/4/data/input.txt")
# |> DayFour.Solution.part_two()
