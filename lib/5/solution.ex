defmodule DayFive.Solution do
  def part_one(key) do
      search(key, :one, 100)
      |> Enum.take(8)
      |> Enum.join()
  end

  def part_two(key) do
    search(key, :two, 300)
    |> Enum.uniq_by(fn {k, _v} -> k end)
    |> Enum.sort(&sort_by_location(&1, &2))
    |> Enum.take(8)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.join()
  end

  def search(key, part, groups) do
    # gurrrl, you make my fans run hot.
    1..groups
    |> Enum.map(&manage_workers(&1, key, part))
    |> Task.yield_many(30_000)
    |> Enum.map(fn {task, res} -> res || Task.shutdown(task, :brutal_kill) end)
    |> Enum.filter_map(&filter(&1), &map_value(&1))
    |> Enum.concat()
  end

  def manage_workers(group_number, key, part) do
    start = 100_000* (group_number - 1)
    stop = 100_000 * group_number
    Task.async(fn -> hack(part, key, {start, stop}, []) end )
  end

  def filter({:ok, [] }), do: false
  def filter({:ok, _ }), do: true
  def filter(_), do: false

  def map_key({ :ok, { key, _value } }), do: key
  def map_value({ :ok, value }), do: value

  def sort_by_location({loc1 , _}, {loc2, _}), do: loc1 < loc2

  def md5_hash(string) do
    :crypto.hash(:md5, string) |> Base.encode16
  end

  def hack(:two, "00000" <> rest, secret, { current, stop }, results) do
    hash = md5_hash "#{secret}#{current + 1}"
    location_string = String.at(rest, 0)
    value = String.at(rest,1)

    results =
      case Integer.parse location_string do
        { location, _ } when location < 8 ->
            IO.puts "#{value} at #{location}"
            [ { location, value } | results ]
        _ -> results
      end

    hack(:two, hash, secret, {current + 1, stop}, results)
  end

  def hack(:one, "00000" <> rest, secret, { current, stop }, results) do
    key = String.at(rest,0)
    hash = md5_hash "#{secret}#{current + 1}"
    IO.puts "#{key} at #{current}"

    hack(:one, hash, secret, {current + 1, stop}, [ key | results ])
  end

  def hack(_, _, _, { current, stop }, results) when current > stop do
     Enum.reverse results
  end

  def hack(part, _hash, secret, {current, stop}, results) do
    hash = md5_hash "#{secret}#{current + 1}"
    hack(part, hash, secret, {current + 1, stop}, results)
  end

  def hack(part, secret, {current, stop} , results) when current < stop do
    hash = md5_hash "#{secret}#{current}"
    hack(part, hash, secret, {current, stop}, results)
  end

end

# IO.inspect DayFive.Solution.part_one("reyedfim")
# IO.inspect DayFive.Solution.part_two("reyedfim")
