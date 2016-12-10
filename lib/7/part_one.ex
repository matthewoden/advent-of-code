defmodule DaySeven.PartOne do

  def solve(stream) do
    stream
    |> Stream.map(fn line -> handle_line(line) end)
    |> Enum.count(fn x -> x end)
  end

  def handle_line(line) do
    line
    |> String.replace("\n", "")
    |> to_charlist
    |> read
  end

  def read(list), do: read(list, false, false)

  # rotate in first and second values
  def read([ a | rest ], valid, inside), do: read(a, rest, valid, inside)
  def read(a, [ b | rest], valid, inside), do: read(a, b, rest, valid, inside)

  # Finish state: With an empty list, we can't match anymore.
  def read(_, _, [ _c | [] ], valid, _), do: valid

  # rotate in third value
  def read(a, b, [ c | rest ], valid, inside) do
    read(a, b, c, rest, valid, inside)
  end
  # possible empty state - return validity.
  def read(_, _, _, [], valid, _), do: valid

  # handle brackets - reset arity
  def read(_, _, _, [ ?[ | rest ], valid, _),  do: read(rest, valid, true)
  def read(_, _, _, [ ?] | rest ], valid, _), do: read(rest, valid, false)

  # rotate in fourth value, evaluate.
  def read(a, b, c, [ d | rest ], valid, inside) do
    has_match = match?(a,b,c,d)
    valid = valid or has_match
    invalid = inside && has_match

    # if invalid, short circuit further evaluation.
    case invalid do
      true -> false
      false -> read(b, c, d, rest, valid, inside)
    end
  end

  def match?(a,b,c,d) when <<a, a, a, a>> == <<a, b, c, d>>, do: false
  def match?(a,b,c,d) when <<a, b, b, a>> == <<a, b, c, d>>, do: true
  def match?(_,_,_,_), do: false

end

File.stream!("./lib/7/data/input.txt")
|> DaySeven.PartOne.solve()
|> IO.inspect
