///| 数字转字符串，可padding前导0
/// 废弃的函数，小时候不懂事写的
pub fn int2str(n : Int, padding~ : Int = 0) -> String {
  let res = "\{n}"
  if res.length() < padding {
    let zeros = String::repeat("0", padding - res.length())
    zeros + res
  } else {
    res
  }
}

///|
pub fn parse_int(s : String) -> Int {
  try {
    @strconv.parse_int!(s)
  } catch {
    _ => panic()
  }
}

///|
pub fn parse_int64(s : String) -> Int64 {
  try {
    @strconv.parse_int64!(s)
  } catch {
    _ => panic()
  }
}

///|
pub fn parse_uint(s : String) -> UInt {
  try {
    @strconv.parse_uint!(s)
  } catch {
    _ => panic()
  }
}

///|
pub fn parse_uint64(s : String) -> UInt64 {
  try {
    @strconv.parse_uint64!(s)
  } catch {
    _ => panic()
  }
}
