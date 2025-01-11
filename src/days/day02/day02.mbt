///| 简单遍历, O(mn)
pub fn part1(idx : Int) -> Int! {
  let input = input!(idx)
  let mut res = input.length()
  for input in input {
    let mut sign = input[1] - input[0]
    for i in 1..<input.length() {
      let new_sign = input[i] - input[i - 1]
      if new_sign.abs() > 3 || new_sign.abs() < 1 || sign * new_sign < 0 {
        res -= 1
        break
      }
      sign = new_sign
    }
  }
  res
}

test "part1" {
  assert_eq!(part1!(0), 369)
  assert_eq!(part1!(1), 2)
}

///| 只有一次机会，找到特异点后尝试删除相邻点即可，O(mn)
pub fn part2(idx : Int) -> Int! {
  let input = input!(idx)
  fn tuple_is_safe(arr : Array[Int], a : Int, b : Int, c : Int) -> Bool {
    if a < 0 || c >= arr.length() {
      return true
    }
    let (a, b, c) = (arr[a], arr[b], arr[c])
    for d in [a - b, b - c] {
      if d.abs() > 3 || d.abs() < 1 {
        return false
      }
    }
    (a - b) * (b - c) > 0
  }

  let mut res = input.length()
  for input in input {
    let mut has_chance = true
    let mut i = 0
    while true {
      if i >= input.length() - 2 {
        break
      }
      if tuple_is_safe(input, i, i + 1, i + 2) {
        i += 1
        continue
      }
      if not(has_chance) {
        res -= 1
        break
      }
      has_chance = false
      if tuple_is_safe(input, i - 1, i + 1, i + 2) &&
        tuple_is_safe(input, i + 1, i + 2, i + 3) {
        i += 1
      } else if tuple_is_safe(input, i - 1, i, i + 2) &&
        tuple_is_safe(input, i, i + 2, i + 3) {
        i += 2
      } else if tuple_is_safe(input, i - 1, i, i + 1) &&
        tuple_is_safe(input, i, i + 1, i + 3) &&
        tuple_is_safe(input, i + 1, i + 3, i + 4) {
        i += 3
      }
    }
  }
  res
}

test "part2" {
  assert_eq!(part2!(0), 428)
  assert_eq!(part2!(1), 4)
}

///| 处理输入
fn input(idx : Int) -> Array[Array[Int]]! {
  let input = @lib.fetch_input!(day=2, idx~)
  let res = []
  for line in input.split("\n") {
    let tmp = []
    for s in line.split(" ") {
      tmp.push(@strconv.parse_int!(s.trim_start(" ")))
    }
    res.push(tmp)
  }
  res
}
