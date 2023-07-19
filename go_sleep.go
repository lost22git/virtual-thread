///usr/bin/env go run "$0" "$@" ; exit $?

package main

import (
	"fmt"
	"os"
	"strconv"
	"sync"
	"time"
)

func main() {
	args := os.Args
	fiberCount := 1024
	if len(args) > 1 {
		num, err := strconv.Atoi(args[1])
		if err != nil {
		}
		if num > 0 {
			fiberCount = num
		}
	}

	var wg sync.WaitGroup
	wg.Add(fiberCount)

	st := time.Now()

	for i := 0; i < fiberCount; i++ {
		go func(wg *sync.WaitGroup) {
			defer wg.Done()
			time.Sleep(3 * time.Second)
		}(&wg)
	}

	wg.Wait()

	elapsed := time.Since(st)
	fmt.Printf("fibers: %d, elapsed: %dms\n", fiberCount, elapsed.Milliseconds())
}
