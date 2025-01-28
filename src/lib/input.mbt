///| 返回第几天的第几个输入。第0个输入是最终输入
pub fn fetch_input(day~ : Int, idx~ : Int) -> String! {
  let day = "\{day}".pad_start(2, '0')
  let path = "src/data/day\{day}/\{idx}.txt"
  @fs.read_file_to_string!(path~)
}

///| 临时函数，代替String::lines
/// 因为现在版本的切片很残缺，下面的代码速度并不快
pub fn lines(s : String) -> Iter[String] {
  let iter = s.split("\n")
  iter.map(fn {
    "" => ""
    line =>
      if line.ends_with("\r") {
        line.substring(end=line.length() - 1)
      } else {
        line
      }
  })
}

///| 临时函数，代替Array[String]::join
pub fn join(s : Array[String], sep : String) -> String {
  let res = StringBuilder::new()
  loop s[:] {
    [s] => {
      res.write_string(s)
      break
    }
    [s, .. r] => {
      res.write_string(s)
      res.write_string(sep)
      continue r
    }
    [] => break
  }
  res.to_string()
}
