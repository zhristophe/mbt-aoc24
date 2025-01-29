///| 宽搜出步数后遍历点
pub fn part1(idx : Int) -> Int! {
  let grid = input!(idx)
  solve(grid, 2)
}

///| 统一的求解函数
fn solve(grid : Array[Array[Char]], cheat_cnt : Int) -> Int {
  let grid = @lib.Grid::from(grid)
  let dis = @lib.Grid::new(grid.size(), @int.max_value)
  let stt = grid.find_point('S').unwrap()
  let end = grid.find_point('E').unwrap()
  dis[end] = 0
  grid
  .bfs_iter_builder()
  .start_from(end)
  .skip_tiles('#')
  .on_discover(fn {
    old, new => dis[new] = @math.minimum(dis[new], dis[old] + 1)
  })
  .run()
  let mut res = 0
  let cnt = @hashmap.new()
  grid
  .bfs_iter_builder()
  .start_from(stt)
  .skip_tiles('#')
  .on_visit(fn(pt) {
    let cur_dis = dis[pt]
    for
      r in @math.maximum(pt.r - cheat_cnt, 0)..=@math.minimum(
        pt.r + cheat_cnt,
        grid.row_count() - 1,
      ) {
      let max_c = cheat_cnt - (pt.r - r).abs()
      for
        c in @math.maximum(pt.c - max_c, 0)..=@math.minimum(
          pt.c + max_c,
          grid.col_count() - 1,
        ) {
        let cheat_pt = @lib.Point::new(r, c)
        let cheat_dis = dis[cheat_pt]
        if cheat_dis == @int.max_value {
          continue
        }
        let cheat_step = (pt.r - r).abs() + (pt.c - c).abs()
        let reserved_step = cur_dis - cheat_dis - cheat_step
        if reserved_step > 0 {
          let new_cnt = match cnt.get(reserved_step) {
            Some(cnt) => cnt + 1
            None => 1
          }
          cnt.set(reserved_step, new_cnt)
        }
        if reserved_step >= 100 {
          res += 1
        }
      }
    }
  })
  .run()
  res
}

///| 同第一部分
pub fn part2(idx : Int) -> Int! {
  let grid = input!(idx)
  solve(grid, 20)
}

///| 处理输入
fn input(idx : Int) -> Array[Array[Char]]! {
  let input = @lib.fetch_input!(day=20, idx~)
  @lib.lines(input).map(fn { line => line.iter().collect() }).collect()
}
