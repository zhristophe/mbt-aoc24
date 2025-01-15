///| 搜索剪枝
pub fn part1(idx : Int) -> UInt64! {
  let input = input!(idx)
  let mut res : UInt64 = 0
  for input in input {
    let (tgt, seq) = input
    if solve(tgt, seq[0], seq[1:], false) {
      res += tgt
    }
  }
  res
}

///|
fn concat(a : UInt64, b : UInt64) -> UInt64 {
  loop a, b {
    a, 0 => break a + b
    a, b => continue a * 10, b / 10
  }
}

///|
fn solve(
  tgt : UInt64,
  acc : UInt64,
  seq : ArrayView[UInt64],
  part2 : Bool
) -> Bool {
  if seq.length() == 0 {
    return tgt == acc
  }
  if acc > tgt {
    return false
  }
  solve(tgt, acc + seq[0], seq[1:], part2) ||
  solve(tgt, acc * seq[0], seq[1:], part2) ||
  (part2 && solve(tgt, concat(acc, seq[0]), seq[1:], part2))
}

///|
pub fn part2(idx : Int) -> UInt64! {
  let input = input!(idx)
  let mut res : UInt64 = 0
  for input in input {
    let (tgt, seq) = input
    if solve(tgt, seq[0], seq[1:], true) {
      res += tgt
    }
  }
  res
}

///| 处理输入
fn input(idx : Int) -> Array[(UInt64, Array[UInt64])]! {
  let input = @lib.fetch_input!(day=7, idx~)
  input
  .split("\n")
  .map(fn {
    line => {
      guard let [tgt, seq] = line.split(": ").collect()
      let tgt = @lib.parse_uint64(tgt)
      let seq = seq
        .split(" ")
        .map(fn { num => @lib.parse_uint64(num) })
        .collect()
      (tgt, seq)
    }
  })
  .collect()
}
