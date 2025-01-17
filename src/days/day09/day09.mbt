///| 模拟
pub fn part1(idx : Int) -> UInt64! {
  let input = input!(idx)
  let mut res : UInt64 = 0
  loop 0, input.length() - 1, 0 {
    left, right, pos => {
      if left > right {
        break res
      }
      match left % 2 {
        0 => {
          let width = input[left]
          res += checksum(val=left / 2, pos~, width~)
          continue left + 1, right, pos + width
        }
        1 => {
          let width = @math.minimum(input[left], input[right])
          res += checksum(val=right / 2, pos~, width~)
          let left = {
            input[left] -= width
            if input[left] == 0 {
              left + 1
            } else {
              left
            }
          }
          let right = {
            input[right] -= width
            if input[right] == 0 {
              right - 2
            } else {
              right
            }
          }
          continue left, right, pos + width
        }
        _ => panic()
      }
    }
  }
}

///| 计算校验和
fn checksum(val~ : Int, pos~ : Int, width~ : Int) -> UInt64 {
  (pos.to_uint64() * 2 + width.to_uint64() - 1) *
  width.to_uint64() /
  2 *
  val.to_uint64()
}

///| 移动留下的空位无法再次利用，不用维护
/// 缓存所有长度空位的位置，0到9
pub fn part2(idx : Int) -> UInt64! {
  let input = input!(idx)
  let pos_vec = input.copy()
  let mut acc = 0
  for i in 0..<pos_vec.length() {
    pos_vec[i] = acc
    acc += input[i]
  }
  let space_map = Array::makei(10, fn { _ => @sorted_set.new() })
  for i in 0..<(input.length() / 2) {
    let space_idx = 2 * i + 1
    space_map[input[space_idx]].add(space_idx)
  }
  let mut res : UInt64 = 0
  loop input.length() - 1 {
    idx => {
      if idx < 0 {
        break res
      }
      let space_idx = space_map[input[idx]:]
        .iter()
        .flat_map(fn { space_idx_list => space_idx_list.iter().peek().iter() })
        .collect()
      space_idx.sort()
      let space_idx = space_idx
        .iter()
        .find_first(fn { space_idx => space_idx < idx })
      let val = idx / 2
      let width = input[idx]
      let pos = match space_idx {
        Some(space_idx) => {
          let pos = pos_vec[space_idx]
          let size = pos_vec[space_idx + 1] - pos
          space_map[size].remove(space_idx)
          pos_vec[space_idx] += width
          space_map[size - width].add(space_idx)
          pos
        }
        None => pos_vec[idx]
      }
      res += checksum(val~, pos~, width~)
      continue idx - 2
    }
  }
}

///| 处理输入
fn input(idx : Int) -> Array[Int]! {
  let input = @lib.fetch_input!(day=9, idx~)
  input.iter().map(fn { num => num.to_int() - '0'.to_int() }).collect()
}
