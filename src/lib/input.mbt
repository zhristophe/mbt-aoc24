///| 返回第几天的第几个输入。第0个输入是最终输入
pub fn fetch_input(day~ : Int, idx~ : Int) -> String! {
  let day = "\{day}".pad_start(2, '0')
  let path = "src/data/day\{day}/\{idx}.txt"
  @fs.read_file_to_string!(path~)
}
