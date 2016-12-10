defmodule DaySeven.PartTwo do

  @initial_state %{
    supernet: MapSet.new,
    hypernet: MapSet.new,
    inside: false,
    valid: false,
  }

  def solve(stream) do
    Stream.map(stream, &handle_line(&1)) |> Enum.count(fn x -> x end)
  end

  def handle_line(line) do
    line
    |> String.replace("\n", "")
    |> to_charlist
    |> read(@initial_state)
  end

  def read(list), do: read(list, false, false)

  # rotate in first and second values
  def read([ a | rest ], state), do: read(a, rest, state)
  def read(a, [ b | rest], state), do: read(a, b, rest, state)

  # less than three values - return validity.
  def read(_, _, [], state), do: state.valid

  # enter and exit brackets - reset arity
  def read(_, _, [ ?[ | rest ], state), do: read(rest, %{ state | inside: true })
  def read(_, _, [ ?] | rest ], state), do: read(rest, %{ state | inside: false })

  # we have all three values - evaluate.
  def read(a, b, [ c | rest ], state) do
    state =
      case match?(a,b,c) do
        true ->  assign_match(state, a,b)
        false -> state
      end

    # we have our answer - short circuit further evaluation
    case state.valid do
      true -> true
      false -> read(b, c, rest, state)
    end
  end

  def assign_match(state, a,b) do
    case state.inside do
      true ->
        %{ state |
          :hypernet => MapSet.put(state.hypernet, <<a,b,a>>),
          :valid => state.valid or MapSet.member?(state.supernet, <<b,a,b>>)
         }
      false ->
        %{ state |
             :supernet => MapSet.put(state.supernet, <<a,b,a>>),
             :valid => state.valid or MapSet.member?(state.hypernet, <<b,a,b>>)
          }
    end
  end

  def match?(a,b,c) when <<a, a, a>> == <<a, b, c>>, do: false
  def match?(a,b,c) when <<a, b, a>> == <<a, b, c>>, do: true
  def match?(_,_,_), do: false

end

File.stream!("./lib/7/data/input.txt")
|> DaySeven.PartTwo.solve
|> IO.inspect
