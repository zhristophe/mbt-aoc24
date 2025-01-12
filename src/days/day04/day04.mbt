///| 简单遍历，复杂度O(mn)
pub fn part1(idx : Int) -> Int! {
  let input = input!(idx)
  let dirs = []
  for i in -1..=1 {
    for j in -1..=1 {
      if i == 0 && j == 0 {
        continue
      }
      dirs.push(@lib.Point::new(i, j))
    }
  }
  let grid = @lib.Grid::from(input)
  let mut res = 0
  let str = "XMAS".to_array()
  for pt in grid.points() {
    for dir in dirs {
      let ok = loop pt, str[:] {
        _, [] => break true
        pt, [ch, .. as t] => {
          guard Some(ch) == grid.get(pt) else { break false }
          continue pt + dir, t
        }
      }
      if ok {
        res += 1
      }
    }
  }
  res
}

///| 遍历所有A，检查四角，复杂度O(mn)
pub fn part2(idx : Int) -> Int! {
  let input = input!(idx)
  let pat = ["MMSS", "MSSM", "SSMM", "SMMS"]
  let pat = pat.map(fn {
    s => s.fold(init=0U, fn { acc, ch => (acc << 8) | ch.to_uint() })
  })
  let grid = @lib.Grid::from(input)
  let dirs = [(-1, -1), (-1, 1), (1, 1), (1, -1)]
  let dirs = dirs.map(fn { d => @lib.Point::new(d.0, d.1) })
  let mut res = 0
  for pt in grid.find_points('A') {
    let mut val = 0U
    for dir in dirs {
      let ch = grid.get(pt + dir).or(' ')
      val = (val << 8) | ch.to_uint()
    }
    if pat.contains(val) {
      res += 1
    }
  }
  res
}

///| 处理输入
fn input(idx : Int) -> Array[Array[Char]]! {
  let input = @lib.fetch_input!(day=4, idx~)
  input.split("\n").map(fn { s => s.to_array() }).collect()
}
