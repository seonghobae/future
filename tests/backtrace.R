source("incl/start.R")

message("*** backtrace( ) ...")

message("*** backtrace( ) - explicit future ...")

f <- future({ 42L; stop("Woops") })
v <- value(f, signal = FALSE)
print(v)
calls <- backtrace(f)
print(calls)

message("*** backtrace( ) - explicit future ... DONE")


message("*** backtrace( ) - implicit future ...")

v %<-% { 42L; stop("Woops") }
calls <- backtrace(v)
print(calls)

message("*** backtrace( ) - implicit future ... DONE")


message("*** backtrace( ) - exceptions ...")

message("- No condition ...")
f <- future(42L)
res <- tryCatch(backtrace(f), error = identity)
print(res)
stopifnot(inherits(res, "error"))

message("- No call stack ...")
f <- future({ 42L; stop("Woops") })
v <- value(f, signal = FALSE)
f$value$traceback <- NULL ## Remove call stack
res <- tryCatch(backtrace(f), error = identity)
print(res)
stopifnot(inherits(res, "error"))

if (availableCores() >= 2L) {
  message("- Non-resolved future ...")
  plan(multiprocess, workers = 2L)
  f <- future({ Sys.sleep(3); 42L; stop("Woops") })
  res <- tryCatch(backtrace(f), error = identity)
  print(res)
  stopifnot(inherits(res, "error"))
}

message("*** backtrace( ) - exceptions ... DONE")


message("*** backtrace( ) ... DONE")

source("incl/end.R")
