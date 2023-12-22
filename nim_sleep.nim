import std/[strformat, strutils]
import std/[os, cmdline]
import std/[times, monotimes]
import std/[coro]

let
  fiberCount =
    try:
      paramStr(1).parseInt
    except:
      1024

echo fmt"{fiberCount = }"

var fibers: seq[CoroutineRef] = @[]

proc doSleep() =
  suspend 3.0

let st = getMonoTime()

for i in 0..<fiberCount:
  fibers.add start(doSleep)

run()

for i in fibers.items:
  i.wait

let ed = getMonoTime()

echo fmt"elapsed: {(ed-st).inMilliseconds}ms"
