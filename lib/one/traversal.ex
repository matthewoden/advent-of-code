defmodule Traversal do

  def plot_route(list) do
    turn_then_move(%{ facing: "N", x: 0, y: 0 }, list)
  end

  def turn_then_move(state, []), do: state
  def turn_then_move(state, [{ direction, distance } | remaining ]) do
    state
    |> turn(direction)
    |> move(distance)
    |> turn_then_move(remaining)
  end

  def turn(state, direction) do
    case direction do
      "L" -> %{ state | :facing => turn_left(state.facing) }
      "R" -> %{ state | :facing => turn_right(state.facing) }
    end
  end

  def move(state, distance) do
    case state.facing do
      "N" -> %{ state | :y => state.y + distance }
      "S" -> %{ state | :y => state.y - distance }
      "E" -> %{ state | :x => state.x + distance }
      "W" -> %{ state | :x => state.x - distance }
    end
  end

  # considered doing an array rotation for these but, eh.
  defp turn_left(direction) do
    case direction do
      "N" -> "W"
      "S" -> "E"
      "E" -> "N"
      "W" -> "S"
    end
  end

  defp turn_right(direction) do
    case direction do
      "N" -> "E"
      "S" -> "W"
      "E" -> "S"
      "W" -> "N"
    end
  end
end
