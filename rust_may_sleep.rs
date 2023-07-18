#!/usr/bin/env rust-script
//! This is a regular crate doc comment, but it also contains a partial
//! Cargo manifest.  Note the use of a *fenced* code block, and the
//! `cargo` "language".
//!
//! ```cargo
//! [dependencies]
//! may = "0.3.42"
//! ```

fn main() {
    // get fiber count from args
    let mut args = std::env::args();
    args.next();
    let fiber = args
        .next()
        .and_then(|v| v.parse::<usize>().ok())
        .unwrap_or(1024);

    let mut handles: Vec<may::coroutine::JoinHandle<()>> = Vec::with_capacity(fiber);

    let st = std::time::Instant::now();

    for _ in 1..=fiber {
        let handle = unsafe {
            may::coroutine::spawn(|| {
                // let st = std::time::Instant::now();
                may::coroutine::sleep(std::time::Duration::from_secs(3));
                // let elapse = st.elapsed();
                // println!("elapse: {elapse:?}");
            })
        };
        handles.push(handle);
    }

    for h in handles {
        h.join().unwrap();
    }

    let elapsed = st.elapsed().as_millis();
    println!("fiber: {fiber}, elapsed: {elapsed:?}ms");
}
