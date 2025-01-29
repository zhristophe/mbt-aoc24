///|
pub fn pow(base : Int, exp : Int) -> Int {
  if exp == 0 {
    1
  } else if exp > 0 {
    let mut res = 1
    for i in 0..<exp {
      res *= base
    }
    res
  } else {
    let mut res = 1
    for i in 0..<exp {
      res /= base
    }
    res
  }
}
