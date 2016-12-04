defmodule Traversal do

  def plot_route(list) do
    state = %{ facing: "N", x: 0, y: 0, blocks: nil, locations: MapSet.new, locationFound: false }
    turn_then_move(state, list)
  end

  def turn_then_move(state, []), do: state
  def turn_then_move(state, [{ direction, distance } | remaining ]) do
    state
    |> turn(direction)
    |> move(distance)
    |> turn_then_move(remaining)
  end

  def move(state, distance), do: move_one(state, distance)
  def move_one(state, 0), do: state
  def move_one(state, distance) do
    state
    |> increment_coordinates
    |> check_location_if_needed
    |> move_one(distance - 1)
  end

  def increment_coordinates(state) do
    case state.facing do
      "N" -> %{ state | :y => state.y + 1 }
      "S" -> %{ state | :y => state.y - 1 }
      "E" -> %{ state | :x => state.x + 1 }
      "W" -> %{ state | :x => state.x - 1 }
    end
  end

  def check_location_if_needed(state) do
    case state.locationFound do
      true ->
        state
      false ->
        check_location(state)
    end
  end

  def check_location(state) do
    location = {state.x, state.y}
    exists = MapSet.member?(state.locations, location)
    case exists do
      true ->
        IO.puts "First repeated instance is #{inspect abs(state.x) + abs(state.y)} blocks away"
        %{ state | :locationFound => true }
      _ ->
        %{ state | :locations => MapSet.put(state.locations, location) }
    end
  end

  def turn(state, direction) do
    case direction do
      "L" -> %{ state | :facing => turn_left(state.facing) }
      "R" -> %{ state | :facing => turn_right(state.facing) }
    end
  end

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
