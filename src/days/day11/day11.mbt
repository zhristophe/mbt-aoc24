///|
pub fn part1(idx : Int) -> UInt64! {
  let input = input!(idx)
  let blinker = Blinker::new()
  input.fold(init=0, fn { acc, num => acc + blinker.blink(num, 25) })
}

///|
struct Blinker {
  cache : @hashmap.T[(UInt64, Int), UInt64]
}

///|
fn Blinker::new() -> Blinker {
  { cache: @hashmap.new() }
}

///| 划分成两个数，n != 0
fn divide(n : UInt64) -> (UInt64, UInt64)? {
  let d = loop n, 0 {
    0, d => break d
    n, d => continue n / 10, d + 1
  }
  if d % 2 == 0 {
    let mut base = 1U.to_uint64()
    for _ in 0..<(d / 2) {
      base *= 10
    }
    Some((n / base, n % base))
  } else {
    None
  }
}

///| 记忆化搜索
fn Blinker::blink(self : Blinker, num : UInt64, times : Int) -> UInt64 {
  if times == 0 {
    return 1
  }
  let key = (num, times)
  match self.cache.get(key) {
    Some(res) => return res
    _ => ()
  }
  let res = if num == 0 {
    self.blink(1, times - 1)
  } else {
    match divide(num) {
      Some((a, b)) => self.blink(a, times - 1) + self.blink(b, times - 1)
      _ => self.blink(num * 2024, times - 1)
    }
  }
  self.cache.set(key, res)
  res
}

///|
pub fn part2(idx : Int) -> UInt64! {
  let input = input!(idx)
  let blinker = Blinker::new()
  input.fold(init=0, fn { acc, num => acc + blinker.blink(num, 75) })
}

///| 处理输入
fn input(idx : Int) -> Array[UInt64]! {
  let input = @lib.fetch_input!(day=11, idx~)
  input.split(" ").map(fn { num => @lib.parse_uint64(num) }).collect()
}
