#!/usr/bin/env crystal

# `sysctl -w vm.max_map_count=65530000`
# debian 默认值为 65530 (64k)
# 如果值太小会导致 Can not allocate fiber stack error
#
# 该测试下的 fiber 内存占用：~10KB/fiber


fiber_count = (ARGV[0]? || "1024").to_i

ch = Channel(Nil).new

st = Time.monotonic

fiber_count.times {
  spawn { 
    sleep 3
    ch.send nil
  }
}

fiber_count.times { ch.receive }

ed = Time.monotonic
elapsed = (ed-st).total_milliseconds

puts "fibers: #{fiber_count}, elapsed: #{elapsed}ms"

