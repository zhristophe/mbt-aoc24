///| 重新染色后遍历所有行和列
pub fn part1(idx : Int) -> Int! {
  let input = input!(idx)
  let grid = @lib.Grid::from(input)
  let (grid, areas) = recolor(grid)
  let edges = Array::make(areas.length(), 0)
  let add_edge = fn {
    pt =>
      match grid.get(pt) {
        Some(color) => edges[color] += 1
        _ => ()
      }
  }
  for row in 0..=grid.row_count() {
    for col in 0..=grid.col_count() {
      let pt = @lib.Point::new(row, col)
      let up = @lib.Point::new(row - 1, col)
      let left = @lib.Point::new(row, col - 1)
      if grid.get(pt) != grid.get(up) {
        add_edge(pt)
        add_edge(up)
      }
      if grid.get(pt) != grid.get(left) {
        add_edge(pt)
        add_edge(left)
      }
    }
  }
  areas.foldi(init=0, fn { idx, acc, area => acc + area * edges[idx] })
}

///| 重新染色，并统计每个颜色的面积
pub fn recolor(grid : @lib.Grid[Char]) -> (@lib.Grid[Int], Array[Int]) {
  let new_grid = @lib.Grid::new(grid.size(), 0)
  let mut color = 0
  let areas = [0]
  for pt in grid.points() {
    if new_grid[pt] != 0 {
      continue
    }
    color += 1
    let mut area = 0
    new_grid
    .bfs_iter_builder()
    .start_from(pt)
    .filter(fn { old, new => grid[new] == grid[old] })
    .on_visit(fn {
      pt => {
        new_grid[pt] = color
        area += 1
      }
    })
    .run()
    areas.push(area)
  }
  (new_grid, areas)
}

///| 类似第一部分
pub fn part2(idx : Int) -> Int! {
  let input = input!(idx)
  let grid = @lib.Grid::from(input)
  let (grid, areas) = recolor(grid)
  let edges = Array::make(areas.length(), 0)
  let count_edges = fn(is_horizontal : Bool) {
    let (row_count, col_count) = if is_horizontal {
      (grid.row_count(), grid.col_count())
    } else {
      (grid.col_count(), grid.row_count())
    }
    for row in 0..=row_count {
      // 记录两边的颜色，因为元组不可迭代，只能用数组。下同
      let mut pr = [None, None]
      // 记录是不是边
      let mut is_edge = [false, false]
      for col in 0..<col_count {
        let next_pr = (
          @lib.Point::new(row - 1, col).transpose(able=not(is_horizontal)),
          @lib.Point::new(row, col).transpose(able=not(is_horizontal)),
        )
        let next_pr = [grid.get(next_pr.0), grid.get(next_pr.1)]
        if next_pr[0] == next_pr[1] {
          is_edge = [false, false]
        } else {
          for i in 0..=1 {
            if next_pr[i] != pr[i] || is_edge[i] == false {
              is_edge[i] = true
              match next_pr[i] {
                Some(color) => edges[color] += 1
                _ => ()
              }
            }
          }
        }
        pr = next_pr
      }
    }
  }
  count_edges(true)
  count_edges(false)
  areas.foldi(init=0, fn { idx, acc, area => acc + area * edges[idx] })
}

///| 处理输入
fn input(idx : Int) -> Array[Array[Char]]! {
  let input = @lib.fetch_input!(day=12, idx~)
  input.split("\n").map(fn { line => line.iter().collect() }).collect()
}
