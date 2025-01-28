///| 单源最短路变体
pub fn part1(idx : Int) -> Int! {
  let input = input!(idx)
  let grid = @lib.Grid::from(input)
  let dis = dijkstra(grid)
  let end = grid.find_point('E').unwrap()
  dis[end].fold(init=@int.max_value, fn { acc, dis => @math.minimum(acc, dis) })
}

///| 用于优先队列
struct Dis {
  dis : Int
  pt : @lib.Point
  dir : @lib.Direction
} derive(Eq)

///|
fn Dis::new(dis : Int, pt : @lib.Point, dir : @lib.Direction) -> Dis {
  { dis, pt, dir }
}

///|
fn Dis::compare(self : Dis, other : Dis) -> Int {
  self.dis.compare(other.dis)
}

///| dijkstra变体
fn dijkstra(map : @lib.Grid[Char]) -> @lib.Grid[Array[Int]] {
  let dis = @lib.Grid::new_with(map.size(), fn {
    _ => Array::make(4, @int.max_value)
  })
  let stt = map.find_point('S').unwrap()
  dis[stt][@lib.Direction::right().to_index()] = 0
  let unvisited = @priority_queue.new()
  unvisited.push(Dis::new(0, stt, @lib.Direction::right()))
  while unvisited.length() > 0 {
    let cur = unvisited.pop().unwrap()
    if dis[cur.pt][cur.dir.to_index()] < cur.dis {
      continue
    }
    for
      dir in [
        (cur.dir, 1),
        (cur.dir.turn_left(), 1001),
        (cur.dir.turn_right(), 1001),
      ] {
      let (dir, new_dis) = dir
      let next = cur.pt.move_to(dir)
      match map.get(next) {
        Some('#') | None => continue
        _ => ()
      }
      let new_dis = cur.dis + new_dis
      if new_dis < dis[next][dir.to_index()] {
        dis[next][dir.to_index()] = new_dis
        unvisited.push(Dis::new(new_dis, next, dir))
      }
    }
  }
  dis
}

///| dijkstra后搜索所有路径 
pub fn part2(idx : Int) -> Int! {
  let input = input!(idx)
  let grid = @lib.Grid::from(input)
  let dis = dijkstra(grid)
  let end = grid.find_point('E').unwrap()
  // 逆方向搜索所有满足的点
  let mut res = 0
  let visited = @lib.Grid::new(grid.size(), false)
  let queue = @queue.new()
  let min_dis = dis[end].fold(init=@int.max_value, fn {
    acc, dis => @math.minimum(acc, dis)
  })
  for dir in @lib.dirs() {
    if dis[end][dir.to_index()] == min_dis {
      queue.push((end, dir))
    }
  }
  while queue.is_empty() == false {
    let (pt, dir) = queue.pop().unwrap()
    if visited.get_and_set(pt, true) == Some(false) {
      res += 1
    }
    let dis_ = dis[pt][dir.to_index()]
    let prev_pt = pt.move_to(dir.turn_around())
    for
      prev_dir in [(dir, 1), (dir.turn_left(), 1001), (dir.turn_right(), 1001)] {
      let (prev_dir, diff) = prev_dir
      if dis[prev_pt][prev_dir.to_index()] == dis_ - diff {
        queue.push((prev_pt, prev_dir))
      }
    }
  }
  res
}

///| 处理输入
fn input(idx : Int) -> Array[Array[Char]]! {
  let input = @lib.fetch_input!(day=16, idx~)
  @lib.lines(input).collect().map(fn { line => line.iter().collect() })
}
