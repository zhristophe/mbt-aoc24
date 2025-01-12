test "grid_points" {
  let grid = [[1, 2, 3], [4, 5, 6]]
  let grid = Grid::from(grid)
  assert_eq!(grid.points().collect(), [
    Point::new(0, 0),
    Point::new(0, 1),
    Point::new(0, 2),
    Point::new(1, 0),
    Point::new(1, 1),
    Point::new(1, 2),
  ])
}

test "grid_find_point" {
  let grid = [[1, 2, 3], [4, 5, 6]]
  let grid = Grid::from(grid)
  assert_eq!(grid.find_point(1), Some(Point::new(0, 0)))
  assert_eq!(grid.find_point(2), Some(Point::new(0, 1)))
  assert_eq!(grid.find_point(3), Some(Point::new(0, 2)))
  assert_eq!(grid.find_point(4), Some(Point::new(1, 0)))
  assert_eq!(grid.find_point(5), Some(Point::new(1, 1)))
  assert_eq!(grid.find_point(6), Some(Point::new(1, 2)))
  assert_eq!(grid.find_point(7), None)
}

test "grid_find_points" {
  let grid = [[1, 2, 3], [1, 1, 1]]
  let grid = Grid::from(grid)
  assert_eq!(grid.find_points(1).collect(), [
    Point::new(0, 0),
    Point::new(1, 0),
    Point::new(1, 1),
    Point::new(1, 2),
  ])
}

test "grid_bfs" {
  let grid =
    #|S#E
    #|.#.
    #|...
  let grid = grid.split("\n").map(fn { s => s.to_array() }).collect()
  let grid = Grid::from(grid)
  let stt = grid.find_point('S').unwrap()
  let end = grid.find_point('E').unwrap()
  let steps = Grid::new(grid.size(), @int.max_value)
  steps.set(stt, 0)
  grid
  .bfs_iter_builder(stt)
  .skip_tiles('#')
  .on_discover(fn { old, new => steps.set(new, steps[old] + 1) })
  .run_with_target(end)
  assert_eq!(
    steps,
    Grid::from([[0, @int.max_value, 6], [1, @int.max_value, 5], [2, 3, 4]]),
  )
}

test "point_move" {
  let p = Point::new(1, 2)
  assert_eq!(p.move_to(Direction::up()), Point::new(0, 2))
  assert_eq!(p.move_to(Direction::down()), Point::new(2, 2))
  assert_eq!(p.move_to(Direction::left()), Point::new(1, 1))
  assert_eq!(p.move_to(Direction::right()), Point::new(1, 3))
}
