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
