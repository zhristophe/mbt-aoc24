///| 解二元一次方程组
pub fn part1(idx : Int) -> Int64! {
  let input = input!(idx)
  let mut res : Int64 = 0
  for input in input {
    guard let Some((a, b)) = solve(input) else { _ => continue }
    if a >= 0 && b >= 0 {
      res += a * 3 + b
    }
  }
  res
}

///|
fn solve(eqs : Array[Int64]) -> (Int64, Int64)? {
  // a.x * a + b.x * b = c.x
  // a.y * a + b.y * b = c.y
  guard let [ax, ay, bx, by, cx, cy] = eqs else { _ => return None }
  let da = ax * by - bx * ay
  if da == 0 {
    return None
  }
  let c = cx * by - cy * bx
  if c % da != 0 {
    return None
  }
  let a = c / da
  if (cx - ax * a) % bx != 0 {
    return None
  }
  let b = (cx - ax * a) / bx
  Some((a, b))
}

///| 同第一部分
pub fn part2(idx : Int) -> Int64! {
  let input = input!(idx)
  let mut res : Int64 = 0
  let off : Int64 = 10000000000000
  for input in input {
    input[4] += off
    input[5] += off
    guard let Some((a, b)) = solve(input) else { _ => continue }
    if a >= 0 && b >= 0 {
      res += a * 3 + b
    }
  }
  res
}

///| 处理输入
fn input(idx : Int) -> Array[Array[Int64]]! {
  let input = @lib.fetch_input!(day=13, idx~)
  let pat = @regexp.compile!(
    #|Button A: X\+(\d+), Y\+(\d+)
    #|Button B: X\+(\d+), Y\+(\d+)
    #|Prize: X=(\d+), Y=(\d+)
    ,
  )
  input
  .split("\n")
  .map(fn {
    line =>
      pat.matches(line).captures()[1:].map(fn { x => @lib.parse_int64(x) })
  })
  .collect()
}
