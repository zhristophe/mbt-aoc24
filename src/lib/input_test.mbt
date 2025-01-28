test "test_lines" {
  let s =
    #|123
    #|456
    #|
    #|abc
  assert_eq!(lines(s).collect(), ["123", "456", "", "abc"])
  assert_eq!(lines(s).collect().split(fn { s => s.is_empty() }), [
    ["123", "456"],
    ["abc"],
  ])
}
