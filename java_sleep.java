///usr/bin/env jbang "$0" "$@" ; exit $?

import java.util.concurrent.Executors;
import static java.lang.System.out;

//JAVA 20
//NATIVE_OPTIONS --no-fallback -H:+ReportExceptionStackTraces --enable-preview --enable-monitoring
//COMPILE_OPTIONS --enable-preview --release 20
//RUNTIME_OPTIONS --enable-preview -XX:+UseZGC

//TODO: RUNTIME_OPTIONS -XX:NativeMemoryTracking=summary -XX:+HeapDumpOnOutOfMemoryError -XX:StartFlightRecording=filename=jfr/,path-to-gc-roots=true,jdk.ObjectCount#enabled=true

public class java_sleep {

  public static void main(String[] args) {
    var fiberCount = args.length == 0 ? 1024 : Integer.parseInt(args[0]);
    long st = System.nanoTime();

    try(var executor = Executors.newVirtualThreadPerTaskExecutor()) {
      for(int i=0;i<fiberCount;i++) {
        executor.execute(()->{
          try{
            Thread.sleep(3000);
          } catch(Exception ignore) {  }
        });
      }
    }

    long ed = System.nanoTime();
    out.println("fibers: %d, elapsed: %dms".formatted(fiberCount, (ed-st)/1000_000));
  }
}
