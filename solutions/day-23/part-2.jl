struct LinkedList
  next :: Vector{Int32}
end

function readinput(fn)
  [Int(c) - Int('0') for c in strip(read(fn, String))]
end

function run!(list :: LinkedList, current_cup :: Int, n :: Int)
  wrap(n) = mod1(n, length(list.next))
  for _ in 1:n
    picked_up_1 = list.next[current_cup]
    picked_up_2 = list.next[picked_up_1]
    picked_up_3 = list.next[picked_up_2]
    after_picked_up = list.next[picked_up_3]
    list.next[current_cup] = after_picked_up

    target_cup = wrap(current_cup - 1)
    while target_cup in (picked_up_1, picked_up_2, picked_up_3)
      target_cup = wrap(target_cup - 1)
    end
    after_target_cup = list.next[target_cup]

    list.next[target_cup] = picked_up_1
    list.next[picked_up_3] = after_target_cup

    current_cup = after_picked_up
  end
end

function play(numbers)
  N = 10^6
  list = LinkedList(Int32[])
  sizehint!(list.next, N)
  indexof(n) = findfirst(i -> i == mod1(n, length(numbers)), numbers)
  for n in 1:length(numbers)
    push!(list.next, numbers[mod1(indexof(n) + 1, length(numbers))])
  end
  for n in (length(numbers)+1):10^6
    push!(list.next, n+1)
  end
  list.next[N] = first(numbers)
  list.next[last(numbers)] = length(numbers)+1

  run!(list, first(numbers), 10^7)
  return Int64(list.next[1]) * list.next[list.next[1]]
end


readinput("input.txt") |> play |> println