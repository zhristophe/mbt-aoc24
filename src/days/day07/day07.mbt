///| 搜索剪枝
pub fn part1(idx : Int) -> UInt64! {
  let input = input!(idx)
  let mut res : UInt64 = 0
  for input in input {
    let (tgt, seq) = input
    if solve(tgt, seq.length() - 1, seq, false) {
      res += tgt
    }
  }
  res
}

///| 从后往前推，能利用整除、尾数等来提前剪枝
fn solve(tgt : UInt64, idx : Int, seq : Array[UInt64], part2 : Bool) -> Bool {
  if idx == 0 {
    return tgt == seq[0]
  }
  let val = seq[idx]
  if tgt < val {
    return false
  }
  if solve(tgt - val, idx - 1, seq, part2) {
    return true
  }
  if tgt % val == 0 && solve(tgt / val, idx - 1, seq, part2) {
    return true
  }
  if part2 {
    let new_tgt = loop tgt, val {
      tgt, 0 => break Some(tgt)
      tgt, seq0 => {
        if tgt % 10 != seq0 % 10 {
          break None
        }
        continue tgt / 10, seq0 / 10
      }
    }
    match new_tgt {
      Some(tgt) => if solve(tgt, idx - 1, seq, part2) { return true }
      None => ()
    }
  }
  false
}

///|
pub fn part2(idx : Int) -> UInt64! {
  let input = input!(idx)
  let mut res : UInt64 = 0
  for input in input {
    let (tgt, seq) = input
    if solve(tgt, seq.length() - 1, seq, true) {
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
