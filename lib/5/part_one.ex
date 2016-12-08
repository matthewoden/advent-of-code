defmodule DayFive.Solution do
  def part_one(key) do
      1..100
      |> Enum.map(
          fn x ->
            Task.async(fn -> hack(key, 100_000*(x-1), 100_000*x, []) end )
          end)
      |> Task.yield_many(30_000)
      |> Enum.map(fn {task, res} ->   res || Task.shutdown(task, :brutal_kill) end)
      |> Enum.filter_map(fn # TODO: clean this up later
          {:ok, [] } -> false
          {:ok, _ } -> true
          _ -> false
         end,
         fn {:ok, value } -> value
         end)
      |> Enum.concat()
      |> Enum.take(8)
      |> Enum.join()
  end

  def hack("00000" <> rest, secret, current, stop, results) do
    key = String.first(rest)
    hack(secret, current + 1, stop, [ key | results ])
  end

  def hack(_,_, current, stop, results) when current > stop, do: Enum.reverse results

  def hack(_hash, secret, current, stop, results) do
    hash = "#{secret}#{current+1}" |> md5_hash
    hack(hash, secret, current+1, stop, results)
  end

  def hack(secret, current, stop, results) when current < stop do
    hash = "#{secret}#{current}" |> md5_hash
    hack(hash, secret, current, stop, results)
  end

  def md5_hash(string) do
    :crypto.hash(:md5, string) |> Base.encode16
  end
end

IO.inspect DayFive.Solution.part_one("reyedfim")
