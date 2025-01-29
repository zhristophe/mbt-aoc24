///| 记忆化搜索
pub fn part1(idx : Int) -> Int! {
  let (towels, desired) = input!(idx)
  let cache = @hashmap.new()
  desired.fold(init=0, fn {
    acc, desired =>
      if count(desired, towels, cache) > 0 {
        acc + 1
      } else {
        acc
      }
  })
}

///| 统计组成方式
fn count(
  desired : String,
  towels : Array[String],
  cache : @hashmap.T[String, Int64]
) -> Int64 {
  if desired.is_empty() {
    return 1
  }
  match cache.get(desired) {
    Some(cnt) => return cnt
    _ => ()
  }
  let mut cnt : Int64 = 0
  for towel in towels {
    if desired.starts_with(towel) {
      cnt += count(desired.substring(start=towel.length()), towels, cache)
    }
  }
  cache[desired] = cnt
  cnt
}

///| 同第一部分
pub fn part2(idx : Int) -> Int64! {
  let (towels, desired) = input!(idx)
  let cache = @hashmap.new()
  desired.fold(init=0, fn {
    acc, desired => acc + count(desired, towels, cache)
  })
}

///| 处理输入
fn input(idx : Int) -> (Array[String], Array[String])! {
  let input = @lib.fetch_input!(day=19, idx~)
  let (towels, desired) = @lib.lines(input).collect().split_at(1)
  (towels[0].split(", ").collect(), desired.split_at(1).1)
}
