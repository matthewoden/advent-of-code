defmodule DayEight.Solution do
  @initial_state %{
    screen: screen

  }

  def part_one do

  end

  # 6 rows, with 50 columns.
  def screen do
    1..6 |> Enum.map( fn -> 1..50 |> Enum.map(fn -> false end) end )
  end

  def rect(x, y, state) do

  end

  def rotate_column(col, amount) do

  end

  def rotate_row(row, amount) do

  end
end
