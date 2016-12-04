defmodule DayThreePartTwo do
  def main() do
    File.stream!("./lib/3/data/input.txt")
    |> Stream.map(&format_lines/1)
    |> Enum.reduce(%{list: [], count: 0}, fn (item, acc) -> group_in_threes(item, acc) end)
    |> format_output
  end

  def format_lines(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&format_line/1)
  end

  def format_line(line) do
    line
    |> String.split("  ", trim: true)
    |> Enum.map(fn item -> item |> String.trim |> String.to_integer end)
  end

  def format_output(%{count: count}) do
    IO.puts "Day 3 - Part 2: #{count}"
  end

  def group_in_threes(curr, %{list: [], count: count}) do
     %{ list: [curr], count: count }
  end

  def group_in_threes(curr, %{list: [ a ], count: count}) do
     %{ list: [ curr, a ], count: count }
  end

  def group_in_threes(curr, %{list: [ a , b ], count: count}) do
      count = count + check_group(curr, a, b)
     %{ list: [] , count: count }
  end

  def check_group([a1, a2, a3], [b1, b2, b3],  [c1, c2, c3]) do
    Enum.count([
      [a1, b1, c1],
      [a2, b2, c2],
      [a3, b3, c3],
    ], fn item -> check_triangle(item) end)
  end

  def check_triangle([a, b, c]) do
    (a + b > c) and (a + c > b) and (b + c > a)
  end
end

# DayThreePartTwo.main()
