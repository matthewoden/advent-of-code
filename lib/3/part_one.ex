defmodule DayThreePartOne do
  def main() do
    File.stream!("./lib/3/data/input.txt")
    |> Stream.map(&format_line/1)
    |> Enum.count(fn item -> item == true end)
    |> IO.inspect
  end

  def format_line(line) do
    String.trim(line,"\n")
    |> String.split("  ", trim: true)
    |> Enum.map(fn item -> String.trim(item) |> String.to_integer end)
    |> check_possiblity
  end

  def check_possiblity([a,b,c]), do: (a + b > c) and (a + c > b) and (b + c > a)
end



# DayThreePartOne.main()
