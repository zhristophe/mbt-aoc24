///| 简简单单bfs
pub fn part1(idx : Int) -> Int! {
  let input = input!(idx)
  let (side, cnt) = match idx {
    0 => (71, 1024)
    _ => (7, 12)
  }
  let grid = @lib.Grid::new((side, side), @int.max_value)
  for pt in input.iter().take(cnt) {
    grid[@lib.Point::new(pt.1, pt.0)] = -1
  }
  let stt = @lib.Point::new(0, 0)
  let end = @lib.Point::new(side - 1, side - 1)
  grid[stt] = 0
  grid
  .bfs_iter_builder()
  .start_from(stt)
  .skip_tiles(-1)
  .on_discover(fn {
    old, new => grid[new] = @math.minimum(grid[new], grid[old] + 1)
  })
  .run_with_target(end)
  grid[end]
}

///| bfs + 二分查找
pub fn part2(idx : Int) -> String! {
  let input = input!(idx)
  let side = match idx {
    0 => 71
    _ => 7
  }
  let stt = @lib.Point::new(0, 0)
  let end = @lib.Point::new(side - 1, side - 1)
  let idx = loop 0, input.length() {
    l, r => {
      if l == r - 1 {
        break l
      }
      let mid = (l + r) / 2
      let grid = @lib.Grid::new((side, side), '.')
      for pt in input.iter().take(mid) {
        grid[@lib.Point::new(pt.1, pt.0)] = '#'
      }
      let mut able = false
      grid
      .bfs_iter_builder()
      .start_from(stt)
      .skip_tiles('#')
      .on_visit(fn { pt => if pt == end { able = true } })
      .run_with_target(end)
      if able {
        continue mid, r
      } else {
        continue l, mid
      }
    }
  }
  let res = input[idx]
  "\{res.0},\{res.1}"
}

///| 处理输入
fn input(idx : Int) -> Array[(Int, Int)]! {
  let input = @lib.fetch_input!(day=18, idx~)
  @lib.lines(input)
  .map(fn(line) {
    guard let [i, j] = line
      .split(",")
      .collect()
      .map(fn { s => @lib.parse_int(s) })
    (i, j)
  })
  .collect()
}
