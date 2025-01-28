///| 模拟
pub fn part1(idx : Int) -> Int! {
  let input = input!(idx)
  let (col_cnt, row_cnt) = match idx {
    0 => (101, 103)
    _ => (11, 7)
  }
  let cnt = [0, 0, 0, 0]
  for pt in get_points(row_cnt, col_cnt, input, 100) {
    let (r, c) = (pt.0, pt.1)
    let r = if r < row_cnt / 2 {
      0
    } else if r > row_cnt / 2 {
      1
    } else {
      continue
    }
    let c = if c < col_cnt / 2 {
      0
    } else if c > col_cnt / 2 {
      1
    } else {
      continue
    }
    cnt[r * 2 + c] += 1
  }
  cnt[0] * cnt[1] * cnt[2] * cnt[3]
}

///| 获取某个时刻的点
fn get_points(
  row_cnt : Int,
  col_cnt : Int,
  p_and_v : Array[Array[Int]],
  time : Int
) -> Array[(Int, Int)] {
  p_and_v.map(fn(arr) {
    guard let [pc, pr, vc, vr] = arr
    let (r, c) = ((pr + vr * time) % row_cnt, (pc + vc * time) % col_cnt)
    let r = if r < 0 { r + row_cnt } else { r }
    let c = if c < 0 { c + col_cnt } else { c }
    (r, c)
  })
}

///| 获取某个时刻的网格
fn get_grid(
  row_cnt : Int,
  col_cnt : Int,
  p_and_v : Array[Array[Int]],
  time : Int
) -> @lib.Grid[Int] {
  let grid = @lib.Grid::new((row_cnt, col_cnt), 0)
  get_points(row_cnt, col_cnt, p_and_v, time).each(fn {
    pt => grid.update(@lib.Point::new(pt.0, pt.1), fn { v => v + 1 })
  })
  grid
}

///| 根据点的聚集程度寻找候选
fn find_candidates(maxn : Int) -> Unit! {
  if maxn == 0 {
    return
  }
  let input = input!(0)
  let (col_cnt, row_cnt) = (101, 103)
  let mut n = 0
  for time in 0..<maxn {
    let grid = get_grid(row_cnt, col_cnt, input, time)
    let mut cnt = 0
    for pt in grid.points() {
      let adj = grid.find_adj(pt).filter(fn { pt => grid[pt] > 0 }).count()
      if adj >= 2 {
        cnt += 1
      }
    }
    if cnt >= input.length() / 2 {
      n += 1
      println(time)
      grid.display(fn { _, v => if v > 0 { "#" } else { "." } })
    }
  }
  println("find \{n} candidates")
}

test "day14_find_candidates" {
  find_candidates!(0)
}

///| 当有16个连续点时
pub fn part2(idx : Int) -> Int! {
  let input = input!(idx)
  let (col_cnt, row_cnt) = match idx {
    0 => (101, 103)
    _ => (11, 7)
  }
  loop 0 {
    time => {
      let pts = get_points(row_cnt, col_cnt, input, time)
      pts.sort()
      loop 0 {
        i => {
          if i >= pts.length() - 16 {
            break
          }
          let d = loop 1 {
            d => {
              if d > 16 {
                return time
              }
              if pts[i].0 != pts[i + d].0 || pts[i].1 + d != pts[i + d].1 {
                break d
              }
              continue d + 1
            }
          }
          continue i + d
        }
      }
      continue time + 1
    }
  }
}

///| 处理输入
fn input(idx : Int) -> Array[Array[Int]]! {
  let input = @lib.fetch_input!(day=14, idx~)
  let pat = @regexp.compile!(
    #|p=(\d+),(\d+) v=(-?\d+),(-?\d+)
    ,
  )
  @lib.lines(input)
  .map(fn {
    line => pat.matches(line).captures()[1:].map(fn { x => @lib.parse_int(x) })
  })
  .collect()
}
