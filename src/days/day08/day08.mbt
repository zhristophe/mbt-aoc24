///| 枚举
pub fn part1(idx : Int) -> Int! {
  let input = input!(idx)
  let grid = @lib.Grid::from(input)
  let points = search_points(grid)
  let mut res = 0
  let record = @lib.Grid::new(grid.size(), false)
  for _, pts in points {
    for i, pt0 in pts {
      for pt1 in pts[i + 1:] {
        for pt in [pt0.times(2) - pt1, pt1.times(2) - pt0] {
          if record.get_and_set(pt, true) == Some(false) {
            res += 1
          }
        }
      }
    }
  }
  res
}

///| 按名称归类点
fn search_points(grid : @lib.Grid[Char]) -> @hashmap.T[Char, Array[@lib.Point]] {
  let points = @hashmap.new()
  for pt in grid.points() {
    let tile = grid[pt]
    if tile != '.' {
      if points.contains(tile) == false {
        points[tile] = [pt]
      } else {
        points[tile].unwrap().push(pt)
      }
    }
  }
  points
}

///|
pub fn part2(idx : Int) -> Int! {
  let input = input!(idx)
  let grid = @lib.Grid::from(input)
  let points = search_points(grid)
  let mut res = 0
  let record = @lib.Grid::new(grid.size(), false)
  for _, pts in points {
    for i, pt0 in pts {
      for pt1 in pts[i + 1:] {
        fn process_pair(
          record : @lib.Grid[Bool],
          pt0 : @lib.Point,
          pt1 : @lib.Point
        ) {
          let d = pt0 - pt1
          loop pt0 {
            pt =>
              match record.get_and_set(pt, true) {
                Some(f) => {
                  if f == false {
                    res += 1
                  }
                  continue pt + d
                }
                None => break
              }
          }
        }

        process_pair(record, pt0, pt1)
        process_pair(record, pt1, pt0)
      }
    }
  }
  res
}

///| 处理输入
fn input(idx : Int) -> Array[Array[Char]]! {
  let input = @lib.fetch_input!(day=8, idx~)
  @lib.lines(input).map(fn { line => line.to_array() }).collect()
}
