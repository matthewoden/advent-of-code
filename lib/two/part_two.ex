defmodule Two do
  def main do
    IO.puts("---------")
    File.read!("./lib/two/data/input.txt")
    |> format_input
    |> traverse
    |> format_output
  end

  def format_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn (line) -> String.trim(line) |> String.to_charlist end)
  end

  @keypad [

    [nil, nil,  '1' ],
    [nil,   '2','3','4' ],
    [   '5','6','7','8','9' ],
    [nil,   'A','B','C' ],
    [nil, nil,  'D' ],

  ]

  @initial_state %{
    :x => 0, :y => 2,
    :key => [],
    ?U => 0, ?D => 0,   ?L => 0, ?R => 4
  }

  def traverse(lines) do
    traverse_line(@initial_state, lines)
  end

  def traverse_line(state, []), do: state
  def traverse_line(state, [ directions | remaining_lines] ) do
    state
    |> route_path(directions)
    |> get_keypad_value
    |> traverse_line(remaining_lines)
  end

  def format_output(state) do
    IO.puts "Day 2, Part 2: #{inspect state.key |> Enum.reverse |> Enum.join}"
  end

  def route_path(state, []), do: state
  def route_path(state, [ current | remaining_steps ] ) do
    state
    |> move(current)
    |> route_path(remaining_steps)
  end

  def move(state, ?U), do: move(state, ?U, :y, -1)
  def move(state, ?D), do: move(state, ?D, :y,  1)
  def move(state, ?R), do: move(state, ?R, :x,  1)
  def move(state, ?L), do: move(state, ?L, :x, -1)

  def move(state, direction, axis, amount) do
    case state[direction] do
      0 ->
        state
      _ ->
        new_axis = state[axis] + amount
        delta =   offset(state[axis]) - offset(new_axis)

        Map.put(state, axis, new_axis)
        |> shift_axis_by_direction(direction)
        |> shift_axis_by_delta(axis, delta)
    end
  end

  @opposite %{ ?U => ?D, ?D => ?U, ?L => ?R, ?R => ?L }

  def shift_axis_by_direction(state, direction) do
    value = state[direction]
    opposite_direction = @opposite[direction]
    opposite_value = state[@opposite[direction]]

    %{ state |
        direction => value - 1,
        opposite_direction => opposite_value + 1
     }
  end

  def shift_axis_by_delta(state, :x, delta), do: adjust_vertical(state, delta)
  def shift_axis_by_delta(state, :y, delta), do: adjust_horizontal(state, delta)

  def adjust_horizontal(state, delta) do
    %{ state |
        ?L => state[?L] + delta,
        ?R => state[?R] + delta
     }
  end

  def adjust_vertical(state, delta) do
    %{ state |
        ?U => state[?U] + delta,
        ?D => state[?D] + delta
     }
  end

  def offset(x), do: max(x,2) - min(x,2)

  def get_keypad_value(state) do
    key = @keypad
          |> Enum.at(state.y)
          |> Enum.at(state.x)
    %{ state | :key => [ key | state.key ] }
  end
end

Two.main()
