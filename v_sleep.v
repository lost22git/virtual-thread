///usr/bin/env v -cg -gc none -use-coroutines run "$0" "$@" ; exit $?

import os
import time
import coroutines

fn main() {
  mut fiber_count := (os.args[1] or { "1024" }).int()
  if fiber_count <= 0 {
    fiber_count = 1024
  }

  mut threads := []thread { cap: fiber_count }

  sw := time.new_stopwatch()

	for _ in 0 .. fiber_count {
		threads << spawn fn () {
      coroutines.sleep(3 * time.second)
    }()
  }

	_ := threads.wait()

  elapsed := sw.elapsed().milliseconds()
	println('fibers: ${fiber_count}, elapsed: ${elapsed}ms')
}


