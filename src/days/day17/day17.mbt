///| 模拟执行
pub fn part1(idx : Int) -> String! {
  let (reg, prog) = input!(idx)
  let res = []
  while reg[0] != 0 {
    res.append(exec_one_cycle(reg, prog))
  }
  @lib.join(res.map(fn { n => n.to_string() }), ",")
}

///| 执行一轮，只适用于以3 0结尾的程序
fn exec_one_cycle(reg : Array[Int64], prog : Array[Int]) -> Array[Int] {
  let res = []
  let combo_opd = fn(opd) {
    match opd {
      0..=3 => opd.to_int64()
      4..=6 => reg[opd - 4]
      _ => panic()
    }
  }
  loop 0 {
    pc => {
      if pc >= prog.length() {
        break
      }
      let (ins, opd) = (prog[pc], prog[pc + 1])
      match ins {
        0 => reg[0] = reg[0] >> combo_opd(opd).to_int()
        1 => reg[1] = reg[1] ^ opd.to_int64()
        2 => reg[1] = combo_opd(opd) & 0b111
        3 => break
        4 => reg[1] = reg[1] ^ reg[2]
        5 => {
          let out = combo_opd(opd) & 0b111
          res.push(out.to_int())
        }
        6 => reg[1] = reg[0] >> combo_opd(opd).to_int()
        7 => reg[2] = reg[0] >> combo_opd(opd).to_int()
        _ => panic()
      }
      continue pc + 2
    }
  }
  res
}

///| 输入里应该有0 3和3 0，回溯搜索符合条件的输入
pub fn part2(idx : Int) -> Int64! {
  let (_, prog) = input!(idx)
  fn dfs(reg_a : Int64, last : Int, prog : Array[Int]) -> Int64? {
    if last == 0 {
      return Some(reg_a)
    }
    for a3 in 0b000..=0b111 {
      let new_reg_a = (reg_a << 3) | a3.to_int64()
      let reg = [new_reg_a, 0, 0]
      let out = exec_one_cycle(reg, prog)
      let out_len = out.length()
      if out[:] == prog[last - out_len:last] {
        match dfs(new_reg_a, last - out_len, prog) {
          Some(res) => return Some(res)
          None => ()
        }
      }
    }
    None
  }

  dfs(0, prog.length(), prog).unwrap()
}

///| 处理输入
fn input(idx : Int) -> (Array[Int64], Array[Int])! {
  let input = @lib.fetch_input!(day=17, idx~)
  let input = @lib.lines(input).collect()
  let reg = input[:3].map(fn(s) {
    let n = s.split(": ").last().unwrap()
    @lib.parse_int64(n)
  })
  let prog = input
    .last()
    .unwrap()
    .split(": ")
    .last()
    .unwrap()
    .split(",")
    .collect()
    .map(fn(s) { @lib.parse_int(s) })
  (reg, prog)
}
