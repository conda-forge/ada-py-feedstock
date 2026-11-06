@echo on
setlocal

cd src\desktop
if errorlevel 1 exit 1

:: Licenses of every crate compiled in, as conda-forge requires for Rust builds.
cargo-bundle-licenses --format yaml --output "%SRC_DIR%\THIRDPARTY.yml"
if errorlevel 1 exit 1

:: --locked: build exactly the committed Cargo.lock. The crate's release profile
:: is size-optimised (opt-level "z", lto, codegen-units 1, strip, panic=abort).
cargo build --release --locked
if errorlevel 1 exit 1

:: conda-forge's rust activation sets CARGO_BUILD_TARGET, which puts the output
:: under target\<triple>\release rather than target\release.
set "OUT=target\release"
if defined CARGO_BUILD_TARGET set "OUT=target\%CARGO_BUILD_TARGET%\release"

if not exist "%LIBRARY_BIN%" mkdir "%LIBRARY_BIN%"
copy /Y "%OUT%\ada-desktop.exe" "%LIBRARY_BIN%\ada-desktop.exe"
if errorlevel 1 exit 1
