///| 排序后比较，O(nlogn)
fn part1(idx : Int) -> Int! {
  let input = input!(idx)
  input.each(fn { vec => vec.sort() })
  let mut res = 0
  for i in 0..<input[0].length() {
    res += (input[0][i] - input[1][i]).abs()
  }
  res
}

test "day01_part1" {
  assert_eq!(part1!(0), 936063)
  assert_eq!(part1!(1), 11)
}

///| 简单遍历, O(n^2)
fn part2(idx : Int) -> Int! {
  let input = input!(idx)
  let mut res = 0
  input[0].each(fn {
    a => input[1].each(fn { b => res += if a == b { a } else { 0 } })
  })
  res
}

test "day01_part2" {
  assert_eq!(part2!(0), 23150395)
  assert_eq!(part2!(1), 31)
}

///| 处理输入
fn input(idx : Int) -> Array[Array[Int]]! {
  let input = @lib.fetch_input!(day=1, idx~)
  let res = [[], []]
  let reg = @regexp.compile!("([0-9]+) +([0-9]+)")
  for line in input.split("\n").collect() {
    let m = reg.matches(line)
    for i in 0..=1 {
      res[i].push(@strconv.parse_int!(m.captures()[i + 1]))
    }
  }
  res
}
