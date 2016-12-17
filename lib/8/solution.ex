defmodule DayEight.Solution do

  def part_one(stream) do
    process_input(stream) |> count_pixels
  end
  def part_two(stream) do
    process_input(stream) |> Enum.map(&create_display(&1))
  end

  def process_input(stream) do
    Enum.reduce(stream, create_screen(), &parse_line(&1, &2))
  end

  def create_display(line) do
    line
    |> Enum.map(fn
        true -> "#"
        false -> " "
      end)
    |> Enum.join()
  end

  def count_pixels(lines) do
    lines
    |> Enum.map(&Enum.count(&1, fn item -> item end))
    |> Enum.sum
  end

  def parse_line("rect "<> rest, screen) do
    [x, y] = split_to_integer(rest, "x")
    rect(x, y, screen)
  end

  def parse_line("rotate row y="<> rest, screen) do
    [index, amount] = split_to_integer(rest, " by ")
    rotate_row(index, amount, screen)
  end

  def parse_line("rotate column x="<>rest, screen) do
    [index, amount] = split_to_integer(rest, " by ")
    rotate_column(index, amount, screen)
  end

  # 6 rows, with 50 columns.
  defp create_screen() do
    1..6 |> Enum.map(fn _ -> 1..50 |> Enum.map(fn _ -> false end) end)
  end

  def rect(x, y, screen), do: rect_rows(screen, [], x, y)

  def rotate_column(index, amount, screen) do
    # improvement = rather than traverse a thousand times, save value at index, and replace on next row.
    screen
    |> collect(index)
    |> Enum.reverse
    |> rotate(amount)
    |> place(screen, index)
  end

  def rotate_row(index, amount, screen) do
    new_row = Enum.at(screen, index) |> Enum.reverse |> rotate(amount)
    screen |> List.replace_at(index, new_row)
  end

  def collect(list, index), do: list |> Enum.map(&Enum.at(&1, index))

  def place(values, lines, index), do: place(values, lines, [], index)
  def place([], [], acc, _), do: Enum.reverse(acc)
  def place([ value | rest_values ], [ line | rest_lines ], acc, index) do
    placed = line |> List.replace_at(index, value)
    place(rest_values, rest_lines, [ placed | acc ], index)
  end

  def split_to_integer(list, split_by) do
    list
    |> String.trim_trailing
    |> String.split(split_by)
    |> Enum.map(fn int -> String.to_integer(int) end)
  end

  # these could all be reduce_while

  def rotate(list, 0), do: Enum.reverse(list)
  def rotate([head | tail], amount), do: rotater(tail ++ [ head ], amount - 1)

  defp rect_rows(list, acc, _x, 0), do: Enum.reverse(acc) |> Enum.concat(list)
  defp rect_rows([head | tail], acc, x, y) do
    row = rect_cols(head, [], x)
    rect_rows(tail, [row | acc], x, y - 1)
  end

  defp rect_cols(list, acc, 0), do: Enum.concat(acc, list)
  defp rect_cols([_ | tail], acc, x), do: rect_cols(tail, [true | acc], x - 1 )



end

File.stream!("./lib/8/data/input.txt")
|> DayEight.Solution.part_one
|> IO.inspect

File.stream!("./lib/8/data/input.txt")
|> DayEight.Solution.part_two
|> IO.inspect
