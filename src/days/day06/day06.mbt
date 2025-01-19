///| 简单模拟
pub fn part1(idx : Int) -> Int! {
  let input = input!(idx)
  let grid = @lib.Grid::from(input)
  let stt = grid.find_point('^').unwrap()
  let visited = patrol(grid, stt).0
  visited
  .points()
  .fold(init=0, fn { acc, pt => acc + (if visited[pt] { 1 } else { 0 }) })
}

///| 简单的巡逻函数，模拟执行
fn patrol(grid : @lib.Grid[Char], stt : @lib.Point) -> (@lib.Grid[Bool], Bool) {
  let visited = @lib.Grid::new(grid.size(), false)
  let stops = @lib.Grid::new(grid.size(), false)
  let res = loop stt, @lib.Direction::up() {
    cur, dir => {
      if visited[cur] == false {
        visited[cur] = true
      }
      let next = cur.move_to(dir)
      match grid.get(next) {
        None => break false
        Some('#') => {
          if stops[cur] == false {
            stops[cur] = true
          } else {
            break true
          }
          let dir = loop dir.turn_right() {
            dir => {
              let next = cur.move_to(dir)
              match grid.get(next) {
                Some('#') => continue dir.turn_right()
                _ => break dir
              }
            }
          }
          continue cur, dir
        }
        _ => continue next, dir
      }
    }
  }
  (visited, res)
}

///|
pub fn part2(idx : Int) -> Int! {
  let input = input!(idx)
  let grid = @lib.Grid::from(input)
  let stt = grid.find_point('^').unwrap()
  let visited = patrol(grid, stt).0
  let mut res = 0
  for pt in grid.points() {
    if visited[pt] && grid[pt] == '.' {
      grid[pt] = '#'
      if patrol(grid, stt).1 {
        res += 1
      }
      grid[pt] = '.'
    }
  }
  res
}

///| 为一行生成缓存
fn generate_cache_for_row(
  cache : @lib.Grid[Array[(Int, @lib.Direction)]],
  grid : @lib.Grid[Char],
  row : Int
) -> Unit {
  // 左
  let mut left = -1
  let mut dir = @lib.Direction::up()
  for c in 0..<grid.col_count() {
    let pt = @lib.Point::new(row, c)
    match grid.get(pt) {
      Some('#') => {
        left = c + 1
        let pt = @lib.Point::new(row - 1, left)
        if Some('#') == grid.get(pt) {
          dir = @lib.Direction::right()
        } else {
          dir = @lib.Direction::up()
        }
      }
      _ => cache[pt][2] = (left, dir)
    }
  }
  // 右
  let mut right = grid.col_count()
  let mut dir = @lib.Direction::down()
  for c in 0..<grid.col_count() {
    let c = grid.col_count() - c - 1
    let pt = @lib.Point::new(row, c)
    match grid.get(pt) {
      Some('#') => {
        right = c - 1
        let pt = @lib.Point::new(row + 1, right)
        if Some('#') == grid.get(pt) {
          dir = @lib.Direction::left()
        } else {
          dir = @lib.Direction::down()
        }
      }
      _ => cache[pt][3] = (right, dir)
    }
  }
}

///| 为一列生成缓存
fn generate_cache_for_col(
  cache : @lib.Grid[Array[(Int, @lib.Direction)]],
  grid : @lib.Grid[Char],
  col : Int
) -> Unit {
  // 上
  let mut up = -1
  let mut dir = @lib.Direction::right()
  for r in 0..<grid.row_count() {
    let pt = @lib.Point::new(r, col)
    match grid.get(pt) {
      Some('#') => {
        up = r + 1
        let pt = @lib.Point::new(up, col + 1)
        if Some('#') == grid.get(pt) {
          dir = @lib.Direction::down()
        } else {
          dir = @lib.Direction::right()
        }
      }
      _ => cache[pt][0] = (up, dir)
    }
  }
  // 下
  let mut down = grid.row_count()
  let mut dir = @lib.Direction::left()
  for r in 0..<grid.row_count() {
    let r = grid.row_count() - r - 1
    let pt = @lib.Point::new(r, col)
    match grid.get(pt) {
      Some('#') => {
        down = r - 1
        let pt = @lib.Point::new(down, col - 1)
        if Some('#') == grid.get(pt) {
          dir = @lib.Direction::up()
        } else {
          dir = @lib.Direction::left()
        }
      }
      _ => cache[pt][1] = (down, dir)
    }
  }
}

///| 实际上更慢 :)
fn patrol_fast(
  grid : @lib.Grid[Char],
  stt : @lib.Point,
  cache : @lib.Grid[Array[(Int, @lib.Direction)]]
) -> Bool {
  let history = @lib.Grid::new_with(grid.size(), fn {
    _ => [false, false, false, false]
  })
  loop stt, @lib.Direction::up() {
    cur, dir => {
      let (next, next_dir) = cache[cur][dir.to_index()]
      let next = match dir {
        @lib.Direction::Up | @lib.Direction::Down => cur.with_row(next)
        @lib.Direction::Left | @lib.Direction::Right => cur.with_col(next)
      }
      if grid.contains(next) == false {
        return false
      }
      if history[cur][dir.to_index()] == true {
        return true
      }
      history[cur][dir.to_index()] = true
      continue next, next_dir
    }
  }
  false
}

///| 枚举障碍位置，缓存停止点的位置以确定循环
pub fn part2_fast(idx : Int) -> Int! {
  let input = input!(idx)
  let grid = @lib.Grid::from(input)
  let stt = grid.find_point('^').unwrap()
  let cache = @lib.Grid::new_with(grid.size(), fn {
    _ => {
      let arr = Array::new(capacity=4)
      for _ in 0..<4 {
        arr.push((0, @lib.Direction::up()))
      }
      arr
    }
  })
  for r in 0..<grid.row_count() {
    generate_cache_for_row(cache, grid, r)
  }
  for c in 0..<grid.col_count() {
    generate_cache_for_col(cache, grid, c)
  }
  let visited = patrol(grid, stt).0
  let mut res = 0
  res = 0
  for pt in grid.points() {
    if visited[pt] && grid[pt] == '.' {
      grid[pt] = '#'
      generate_cache_for_row(cache, grid, pt.r)
      generate_cache_for_col(cache, grid, pt.c)
      if patrol_fast(grid, stt, cache) {
        res += 1
      }
      grid[pt] = '.'
      generate_cache_for_row(cache, grid, pt.r)
      generate_cache_for_col(cache, grid, pt.c)
    }
  }
  res
}

///| 处理输入
fn input(idx : Int) -> Array[Array[Char]]! {
  let input = @lib.fetch_input!(day=6, idx~)
  input.split("\n").map(fn { s => s.to_array() }).collect()
}
