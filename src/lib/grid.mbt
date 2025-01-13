///|
pub struct Grid[T] {
  // XXX: 对于moonbit，由于二维数组内存不连续，转成一维数组理论上会提高效率
  inner : Array[Array[T]]
} derive(Eq, Show)

///| 现版本没有copy trait，因此该函数不可用于复杂类型T
/// 如果T为复杂类型，使用new_with
pub fn Grid::new[T](size : (Int, Int), default : T) -> Grid[T] {
  let inner = Array::new(capacity=size.0)
  for _ in 0..<size.0 {
    let row = Array::new(capacity=size.1)
    for _ in 0..<size.1 {
      row.push(default)
    }
    inner.push(row)
  }
  { inner, }
}

///|
pub fn Grid::new_with[T](size : (Int, Int), f : (Point) -> T) -> Grid[T] {
  let inner = Array::new(capacity=size.0)
  for r in 0..<size.0 {
    let row = Array::new(capacity=size.1)
    for c in 0..<size.1 {
      row.push(f(Point::new(r, c)))
    }
    inner.push(row)
  }
  { inner, }
}

///|
pub fn Grid::from[T](inner : Array[Array[T]]) -> Grid[T] {
  { inner, }
}

///| FIXME: 当T是复杂类型时，copy出的grid中的元素和原来的指向一致
/// XXX: moonbit现版本没有copy trait
pub fn Grid::copy[T](self : Grid[T]) -> Grid[T] {
  { inner: self.inner.map(fn { row => row.copy() }) }
}

///|
pub fn Grid::size[T](self : Grid[T]) -> (Int, Int) {
  (self.inner.length(), self.inner[0].length())
}

///|
pub fn Grid::row_count[T](self : Grid[T]) -> Int {
  self.inner.length()
}

///|
pub fn Grid::col_count[T](self : Grid[T]) -> Int {
  self.inner[0].length()
}

///|
pub fn Grid::get[T](self : Grid[T], pt : Point) -> T? {
  // XXX: 现版本Option没有?操作符？
  self.inner.get(pt.r).bind(fn { row => row.get(pt.c) })
}

///|
pub fn Grid::op_get[T](self : Grid[T], pt : Point) -> T {
  self.inner[pt.r][pt.c]
}

///|
pub fn Grid::set[T](self : Grid[T], pt : Point, val : T) -> Unit {
  if self.contains(pt) {
    self.inner[pt.r][pt.c] = val
  }
}

///|
pub fn Grid::op_set[T](self : Grid[T], pt : Point, val : T) -> Unit {
  self.inner[pt.r][pt.c] = val
}

///|
pub fn Grid::update[T](self : Grid[T], pt : Point, f : (T) -> T) -> Unit {
  if self.contains(pt) {
    self.inner[pt.r][pt.c] = f(self.inner[pt.r][pt.c])
  }
}

///| XXX: 现版本没有is_some
pub fn Grid::contains[T](self : Grid[T], pt : Point) -> Bool {
  self.inner.get(pt.r).is_empty() == false &&
  self.inner[pt.r].get(pt.c).is_empty() == false
}

///| 
pub fn Grid::display[T](self : Grid[T], f : (Point, T) -> String) -> Unit {
  println(self.format(f))
}

///|
pub fn Grid::format[T](self : Grid[T], f : (Point, T) -> String) -> String {
  let mut res = ""
  for r in 0..<self.row_count() {
    for c in 0..<self.col_count() {
      let pt = Point::new(r, c)
      res += f(pt, self[pt])
    }
    res += "\n"
  }
  res
}

///|
pub fn Grid::points[T](self : Grid[T]) -> Iter[Point] {
  Iter::new(fn(yield_) {
    for r in 0..<self.row_count() {
      let v = for c in 0..<self.col_count() {
        guard let IterContinue = yield_(Point::new(r, c)) else { x => break x }

      } else {
        IterContinue
      }
      guard let IterContinue = v else { x => break x }

    } else {
      IterContinue
    }
  })
}

///|
pub fn Grid::find_point[T : Eq](self : Grid[T], val : T) -> Point? {
  self.points().find_first(fn(pt) { self[pt] == val })
}

///|
pub fn Grid::find_points[T : Eq](self : Grid[T], val : T) -> Iter[Point] {
  self.points().filter(fn(pt) { self[pt] == val })
}

///|
pub fn Grid::bfs_iter_builder[T](self : Grid[T], stt : Point) -> BfsIter[T] {
  {
    grid: self,
    stt,
    filter: fn(_) { true },
    discovery_handler: fn(_, _) {  },
    visit_handler: fn(_) {  },
  }
}

///|
struct BfsIter[T] {
  grid : Grid[T]
  stt : Point
  mut filter : (Point) -> Bool
  mut discovery_handler : (Point, Point) -> Unit
  mut visit_handler : (Point) -> Unit
}

///|
pub fn BfsIter::filter[T](self : BfsIter[T], f : (Point) -> Bool) -> BfsIter[T] {
  self.filter = f
  self
}

///|
pub fn BfsIter::skip_tiles[T : Eq](self : BfsIter[T], tile : T) -> BfsIter[T] {
  self.filter = fn(x) { self.grid.get(x) != Some(tile) }
  self
}

///|
pub fn BfsIter::only_tiles[T : Eq](self : BfsIter[T], tile : T) -> BfsIter[T] {
  self.filter = fn(x) { self.grid.get(x) == Some(tile) }
  self
}

///|
pub fn BfsIter::on_discover[T](
  self : BfsIter[T],
  f : (Point, Point) -> Unit
) -> BfsIter[T] {
  self.discovery_handler = f
  self
}

///|
pub fn BfsIter::on_visit[T](
  self : BfsIter[T],
  f : (Point) -> Unit
) -> BfsIter[T] {
  self.visit_handler = f
  self
}

///|
pub fn BfsIter::iter[T](self : BfsIter[T]) -> Iter[Point] {
  Iter::new(fn(yield_) {
    let queue = @queue.new()
    queue.push(self.stt)
    let discovered = Grid::new(self.grid.size(), false)
    let visited = Grid::new(self.grid.size(), false)
    while true {
      let cur = match queue.pop() {
        Some(x) => x
        None => break IterEnd
      }
      visited[cur] = true
      (self.visit_handler)(cur)
      for dir in dirs() {
        let next = cur.move_to(dir)
        if self.grid.contains(next) == false {
          continue
        }
        if discovered[next] || visited[next] {
          continue
        }
        if (self.filter)(next) == false {
          continue
        }
        discovered[next] = true
        (self.discovery_handler)(cur, next)
        queue.push(next)
      }
      if yield_(cur) == IterEnd {
        break IterEnd
      }
    } else {
      IterContinue
    }
  })
}

///|
pub fn BfsIter::run[T](self : BfsIter[T]) -> Unit {
  self.iter().just_run(fn(_) { IterContinue })
}

///|
pub fn BfsIter::run_with_target[T](self : BfsIter[T], tgt : Point) -> Unit {
  self.iter().just_run(fn(a) { if a == tgt { IterEnd } else { IterContinue } })
}

///|
pub struct Point {
  r : Int
  c : Int
} derive(Eq, Show)

///|
pub fn Point::new(r : Int, c : Int) -> Point {
  { r, c }
}

///|
pub fn Point::op_add(self : Point, pt : Point) -> Point {
  Point::new(self.r + pt.r, self.c + pt.c)
}

///|
pub fn Point::times(self : Point, n : Int) -> Point {
  Point::new(self.r * n, self.c * n)
}

///|
pub fn Point::move_to(self : Point, dir : Direction) -> Point {
  self + dir.to_point()
}

///|
pub fn Point::with_row(self : Point, r : Int) -> Point {
  Point::new(r, self.c)
}

///|
pub fn Point::with_col(self : Point, c : Int) -> Point {
  Point::new(self.r, c)
}

///|
pub enum Direction {
  Up
  Down
  Left
  Right
} derive(Eq, Show)

///|
pub fn dirs() -> Array[Direction] {
  [Direction::Up, Direction::Down, Direction::Left, Direction::Right]
}

///| 
pub fn Direction::up() -> Direction {
  Direction::Up
}

///|
pub fn Direction::down() -> Direction {
  Direction::Down
}

///|
pub fn Direction::left() -> Direction {
  Direction::Left
}

///|
pub fn Direction::right() -> Direction {
  Direction::Right
}

///|
pub fn Direction::turn_right(self : Direction) -> Direction {
  match self {
    Direction::Up => Direction::Right
    Direction::Down => Direction::Left
    Direction::Left => Direction::Up
    Direction::Right => Direction::Down
  }
}

///|
pub fn Direction::turn_left(self : Direction) -> Direction {
  match self {
    Direction::Up => Direction::Left
    Direction::Down => Direction::Right
    Direction::Left => Direction::Down
    Direction::Right => Direction::Up
  }
}

///|
pub fn Direction::turn_around(self : Direction) -> Direction {
  match self {
    Direction::Up => Direction::Down
    Direction::Down => Direction::Up
    Direction::Left => Direction::Right
    Direction::Right => Direction::Left
  }
}

///|
pub fn Direction::to_point(self : Direction) -> Point {
  match self {
    Direction::Up => Point::new(-1, 0)
    Direction::Down => Point::new(1, 0)
    Direction::Left => Point::new(0, -1)
    Direction::Right => Point::new(0, 1)
  }
}

///|
pub fn Direction::to_index(self : Direction) -> Int {
  match self {
    Direction::Up => 0
    Direction::Down => 1
    Direction::Left => 2
    Direction::Right => 3
  }
}

///|
pub fn Direction::times(self : Direction, n : Int) -> Point {
  self.to_point().times(n)
}
