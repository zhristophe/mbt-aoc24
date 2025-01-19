///|
fn main {
  try {
    let e = { stt: None }
    for day in 1..=10 {
      for part in 1..=2 {
        e.run!(day, part)
      }
    }
    println("done. cost: \{@env.now() - e.stt.unwrap()}ms")
  } catch {
    err => println(err)
  }
}

///|
struct Executor {
  mut stt : UInt64?
}

///|
type! ExecutorError String

///|
fn Executor::run(self : Executor, day : Int, part : Int) -> Unit! {
  let stt = @env.now()
  if self.stt.is_empty() {
    self.stt = Some(stt)
  }
  let _ans = match (day, part) {
    (1, 1) => @day01.part1!(0).to_string()
    (1, 2) => @day01.part2!(0).to_string()
    (2, 1) => @day02.part1!(0).to_string()
    (2, 2) => @day02.part2!(0).to_string()
    (3, 1) => @day03.part1!(0).to_string()
    (3, 2) => @day03.part2!(0).to_string()
    (4, 1) => @day04.part1!(0).to_string()
    (4, 2) => @day04.part2!(0).to_string()
    (5, 1) => @day05.part1!(0).to_string()
    (5, 2) => @day05.part2!(0).to_string()
    (6, 1) => @day06.part1!(0).to_string()
    (6, 2) => @day06.part2!(0).to_string()
    (7, 1) => @day07.part1!(0).to_string()
    (7, 2) => @day07.part2!(0).to_string()
    (8, 1) => @day08.part1!(0).to_string()
    (8, 2) => @day08.part2!(0).to_string()
    (9, 1) => @day09.part1!(0).to_string()
    (9, 2) => @day09.part2!(0).to_string()
    (10, 1) => @day10.part1!(0).to_string()
    (10, 2) => @day10.part2!(0).to_string()
    _ => raise ExecutorError("invalid day and part: \{day}, \{part}")
  }
  println("day \{day} part \{part} ans: \{_ans}")
  let end = @env.now()
  println("day \{day} part \{part} cost: \{end - stt}ms")
}
