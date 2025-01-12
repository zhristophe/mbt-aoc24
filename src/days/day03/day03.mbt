///| 正则匹配，因为pattern简单，时间复杂度算O(n)
/// 但是moonbit没有良好的正则支持，这里手写递归下降解析器
pub fn part1(idx : Int) -> Int! {
  let input = input!(idx)
  let mut res = 0
  loop input.to_array()[:] {
    [] => break
    input => {
      if input[0] == 'm' {
        let (ok, rest, n1, n2) = parse_mul(input)
        if ok {
          res += n1 * n2
        }
        continue rest
      }
      continue input[1:]
    }
  }
  res
}

test "part1" {
  assert_eq!(part1!(0), 190604937)
  assert_eq!(part1!(1), 161)
}

///| 匹配一个字符串，返回是否匹配，以及剩余的字符串
fn match_str(str : ArrayView[Char], pat : String) -> (Bool, ArrayView[Char]) {
  let pat = pat.to_array()[:]
  loop str, pat {
    str, [] => break (true, str)
    [], _ => break (false, [][:])
    str, [ch, .. as t] => {
      if str[0] != ch {
        break (false, str)
      }
      continue str[1:], t
    }
  }
}

///| 匹配一个整数，返回是否匹配、剩余的字符串和匹配的整数
fn match_int(str : ArrayView[Char]) -> (Bool, ArrayView[Char], Int) {
  loop str, 0, 0 {
    [], len, num => break (len > 0, [][:], num)
    str, len, num => {
      let ch = str[0]
      if ch < '0' || ch > '9' {
        break (len > 0, str, num)
      }
      continue str[1:], len + 1, num * 10 + (ch - '0')
    }
  }
}

///|
fn parse_mul(str : ArrayView[Char]) -> (Bool, ArrayView[Char], Int, Int) {
  let str = match match_str(str, "mul") {
    (false, rest) => return (false, rest, 0, 0)
    (true, rest) => rest
  }
  let str = match match_str(str, "(") {
    (false, rest) => return (false, rest, 0, 0)
    (true, rest) => rest
  }
  let (str, n1) = match match_int(str) {
    (false, rest, _) => return (false, rest, 0, 0)
    (true, rest, n) => {
      if n > 1000 {
        return (false, rest, 0, 0)
      }
      (rest, n)
    }
  }
  let str = match match_str(str, ",") {
    (false, rest) => return (false, rest, 0, 0)
    (true, rest) => rest
  }
  let (str, n2) = match match_int(str) {
    (false, rest, _) => return (false, rest, 0, 0)
    (true, rest, n) => {
      if n > 1000 {
        return (false, rest, 0, 0)
      }
      (rest, n)
    }
  }
  let str = match match_str(str, ")") {
    (false, rest) => return (false, rest, 0, 0)
    (true, rest) => rest
  }
  (true, str, n1, n2)
}

///|
fn parse_do(str : ArrayView[Char]) -> (Bool, ArrayView[Char]) {
  match_str(str, "do()")
}

///|
fn parse_donot(str : ArrayView[Char]) -> (Bool, ArrayView[Char]) {
  match_str(str, "don't()")
}

///| 类似第一问
pub fn part2(idx : Int) -> Int! {
  let input = input!(idx)
  let mut res = 0
  let mut enable = true
  loop input.to_array()[:] {
    [] => break
    input =>
      match input[0] {
        'm' => {
          let (ok, rest, n1, n2) = parse_mul(input)
          if ok && enable {
            res += n1 * n2
          }
          continue rest
        }
        'd' => {
          let (ok, rest) = parse_donot(input)
          if ok {
            enable = false
            continue rest
          }
          let (ok, rest) = parse_do(input)
          if ok {
            enable = true
            continue rest
          }
        }
        _ => continue input[1:]
      }
  }
  res
}

test "part2" {
  assert_eq!(part2!(0), 82857512)
  assert_eq!(part2!(2), 48)
}

///| 处理输入
fn input(idx : Int) -> String! {
  let input = @lib.fetch_input!(day=3, idx~)
  input
}
