///| 简单搜索
pub fn part1(idx : Int) -> Int! {
  let input = input!(idx)
  let grid = @lib.Grid::from(input)
  let mut res = 0
  for stt in grid.find_points(0) {
    grid
    .bfs_iter_builder()
    .start_from(stt)
    .filter(fn { old, new => grid[new] == grid[old] + 1 })
    .on_visit(fn { pt => if grid[pt] == 9 { res += 1 } })
    .run()
  }
  res
}

///| 类似dp
pub fn part2(idx : Int) -> Int! {
  let input = input!(idx)
  let grid = @lib.Grid::from(input)
  let cnt = @lib.Grid::new(grid.size(), 0)
  let stts = grid.find_points(0).collect()
  stts.each(fn { pt => cnt.set(pt, 1) })
  grid
  .bfs_iter_builder()
  .start_from_points(stts)
  .filter(fn { old, new => grid[new] == grid[old] + 1 })
  .on_visit(fn {
    pt =>
      for adj in grid.find_adj(pt) {
        if grid[adj] == grid[pt] + 1 {
          cnt.update(adj, fn { v => v + cnt[pt] })
        }
      }
  })
  .run()
  grid.find_points(9).fold(init=0, fn { acc, v => acc + cnt[v] })
}

///| 处理输入
fn input(idx : Int) -> Array[Array[Int]]! {
  let input = @lib.fetch_input!(day=10, idx~)
  input
  .split("\n")
  .map(fn { line => line.iter().map(fn { c => c - '0' }).collect() })
  .collect()
}
