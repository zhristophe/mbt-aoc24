test "part1" {
  assert_eq!(part1!(0), "2,0,1,3,4,0,2,1,7")
  assert_eq!(part1!(1), "4,6,3,5,6,3,5,2,1,0")
}

test "part2" {
  assert_eq!(part2!(0), 236580836040301)
  assert_eq!(part2!(2), 117440)
}
