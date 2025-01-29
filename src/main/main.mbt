///|
fn main {
  try {
    let e = { stt: None }
    for day in 1..=20 {
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
    (11, 1) => @day11.part1!(0).to_string()
    (11, 2) => @day11.part2!(0).to_string()
    (12, 1) => @day12.part1!(0).to_string()
    (12, 2) => @day12.part2!(0).to_string()
    (13, 1) => @day13.part1!(0).to_string()
    (13, 2) => @day13.part2!(0).to_string()
    (14, 1) => @day14.part1!(0).to_string()
    (14, 2) => @day14.part2!(0).to_string()
    (15, 1) => @day15.part1!(0).to_string()
    (15, 2) => @day15.part2!(0).to_string()
    (16, 1) => @day16.part1!(0).to_string()
    (16, 2) => @day16.part2!(0).to_string()
    (17, 1) => @day17.part1!(0).to_string()
    (17, 2) => @day17.part2!(0).to_string()
    (18, 1) => @day18.part1!(0).to_string()
    (18, 2) => @day18.part2!(0).to_string()
    (19, 1) => @day19.part1!(0).to_string()
    (19, 2) => @day19.part2!(0).to_string()
    (20, 1) => @day20.part1!(0).to_string()
    (20, 2) => @day20.part2!(0).to_string()
    _ => raise ExecutorError("invalid day and part: \{day}, \{part}")
  }
  println("day \{day} part \{part} ans: \{_ans}")
  let end = @env.now()
  println("day \{day} part \{part} cost: \{end - stt}ms")
}
