///| 简单遍历，复杂度O(mn^2)
pub fn part1(idx : Int) -> Int! {
  let (order, seqs) = input!(idx)
  let mut res = 0
  for seq in seqs {
    if is_correct(seq, order) {
      res += seq[seq.length() / 2]
    }
  }
  res
}

///|
fn is_correct(
  seq : Array[Int],
  order : @hashmap.T[Int, @hashset.T[Int]]
) -> Bool {
  for i in 1..<seq.length() {
    let order = order[seq[i]]
    for j in seq[:i] {
      if order.map_or(false, fn { x => x.contains(j) }) {
        return false
      }
    }
  }
  true
}

///| 直接使用sort_by，复杂度O(mn^2)
pub fn part2(idx : Int) -> Int! {
  let (order, seqs) = input!(idx)
  let mut res = 0
  for seq in seqs {
    if is_correct(seq, order) {
      continue
    }
    seq.sort_by(fn {
      a, b =>
        if order[a].map_or(false, fn { x => x.contains(b) }) {
          1
        } else if order[b].map_or(false, fn { x => x.contains(a) }) {
          -1
        } else {
          0
        }
    })
    res += seq[seq.length() / 2]
  }
  res
}

///| 处理输入
fn input(idx : Int) -> (@hashmap.T[Int, @hashset.T[Int]], Array[Array[Int]])! {
  let input = @lib.fetch_input!(day=5, idx~)
  let input = input.split("\n\n").collect()
  let order = @hashmap.new(capacity=100)
  for line in input[0].split("\n") {
    guard let [a, b] = line.split("|").collect()
    order
    .get_or_init(@strconv.parse_int!(a), fn() { @hashset.new() })
    .add(@strconv.parse_int!(b))
  }
  let seqs = []
  for line in input[1].split("\n") {
    let seq = []
    for num in line.split(",") {
      seq.push(@strconv.parse_int!(num))
    }
    seqs.push(seq)
  }
  (order, seqs)
}
