test "int2str" {
  assert_eq!(@lib.int2str(123), "123")
  assert_eq!(@lib.int2str(123, padding=1), "123")
  assert_eq!(@lib.int2str(123, padding=3), "123")
  assert_eq!(@lib.int2str(123, padding=4), "0123")
  assert_eq!(@lib.int2str(123, padding=5), "00123")
  assert_eq!(@lib.int2str(0), "0")
  assert_eq!(@lib.int2str(0, padding=5), "00000")
}
