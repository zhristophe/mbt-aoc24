///| 模拟
pub fn part1(idx : Int) -> Int! {
  let input = input!(idx)
  let grid = @lib.Grid::from(input.0)
  let seq = input.1
  let mut rbt = grid.find_point('@').unwrap()
  grid.set(rbt, '.')
  for dir in seq {
    let dir = match dir {
      '^' => @lib.Direction::up()
      'v' => @lib.Direction::down()
      '<' => @lib.Direction::left()
      '>' => @lib.Direction::right()
      _ => panic()
    }
    let next = rbt.move_to(dir)
    match grid.get(next) {
      Some('#') => ()
      Some('.') => rbt = next
      Some('O') => {
        let space = loop next {
          pt =>
            match grid.get(pt) {
              Some('O') => continue pt.move_to(dir)
              Some('.') => break Some(pt)
              Some('#') => break None
              _ => panic()
            }
        }
        match space {
          Some(space) => {
            grid.set(next, '.')
            grid.set(space, 'O')
            rbt = next
          }
          None => ()
        }
      }
      _ => panic()
    }
  }
  grid
  .points()
  .fold(init=0, fn {
    acc, pt => acc + (if grid[pt] == 'O' { 100 * pt.r + pt.c } else { 0 })
  })
}

///| 更复杂的模拟
pub fn part2(idx : Int) -> Int! {
  let input = input!(idx)
  // 转换
  let grid = input.0.map(fn {
    line =>
      line
      .iter()
      .map(fn {
        '#' => "##"
        '.' => ".."
        'O' => "[]"
        '@' => "@."
        _ => panic()
      })
      .flat_map(fn { s => s.iter() })
      .collect()
  })
  let grid = @lib.Grid::from(grid)
  let seq = input.1
  let mut rbt = grid.find_point('@').unwrap()
  grid.set(rbt, '.')
  for dir in seq {
    let dir = match dir {
      '^' => @lib.Direction::up()
      'v' => @lib.Direction::down()
      '<' => @lib.Direction::left()
      '>' => @lib.Direction::right()
      _ => panic()
    }
    let next = rbt.move_to(dir)
    match grid.get(next) {
      Some('#') => ()
      Some('.') => rbt = next
      Some('[') | Some(']') => {
        // 移动传导
        let box_layers = []
        let able = able~: loop [next] {
          [] => break true
          layer => {
            // 竖直方向增加箱内传导
            match dir {
              @lib.Direction::Up | @lib.Direction::Down =>
                for box in layer {
                  match grid.get(box) {
                    Some('[') => {
                      let other = box.move_to(@lib.Direction::right())
                      if layer.contains(other) == false {
                        layer.push(other)
                      }
                    }
                    Some(']') => {
                      let other = box.move_to(@lib.Direction::left())
                      if layer.contains(other) == false {
                        layer.push(other)
                      }
                    }
                    _ => ()
                  }
                }
              _ => ()
            }
            box_layers.push(layer)
            let next_layer = []
            for box in layer {
              let next = box.move_to(dir)
              match grid.get(next) {
                Some('[') | Some(']') => next_layer.push(next)
                Some('.') => ()
                _ => break able~ false
              }
            }
            continue next_layer
          }
        }
        if able {
          for layer in box_layers.rev_iter() {
            for box in layer {
              grid.set(box.move_to(dir), grid[box])
              grid.set(box, '.')
            }
          }
          rbt = next
        }
      }
      _ => panic()
    }
  }
  grid
  .points()
  .fold(init=0, fn {
    acc, pt => acc + (if grid[pt] == '[' { 100 * pt.r + pt.c } else { 0 })
  })
}

///| 处理输入
fn input(idx : Int) -> (Array[Array[Char]], Array[Char])! {
  let input = @lib.fetch_input!(day=15, idx~)
  guard let [map, seq] = @lib.lines(input)
    .collect()
    .split(fn { s => s.is_empty() })
  (
    map.map(fn { line => line.iter().collect() }),
    seq.iter().flat_map(fn { line => line.iter() }).collect(),
  )
}
