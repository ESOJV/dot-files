#!/bin/bash

# esp-bootstrap: Initialize a new ESP-IDF project with clangd support

CHIP="esp32" # default

# ── Help ──────────────────────────────────────────────────────────────────────
usage() {
  cat << 'EOF'
esp-bootstrap - Initialize an ESP-IDF project with Neovim/clangd support

USAGE
  scripts esp-bootstrap [CHIP] [OPTIONS]

ARGUMENTS
  CHIP        Target chip (default: esp32)
              Supported: esp32, esp32s2, esp32s3, esp32c3, esp32c6, esp32h2

OPTIONS
  -h, --help  Show this help message

WHAT IT DOES
  1. Creates a .clangd file configured for the target chip
  2. Creates a .gitignore with standard ESP-IDF build artifacts
  3. Runs idf.py set-target <chip>
  4. Runs idf.py build to generate compile_commands.json for clangd

REQUIREMENTS
  get-idf must be sourced before running this script

EXAMPLES
  scripts esp-bootstrap                initialize for esp32 (default)
  scripts esp-bootstrap esp32s3        initialize for ESP32-S3
  scripts esp-bootstrap esp32c6        initialize for ESP32-C6
EOF
}

# ── Parse arguments ───────────────────────────────────────────────────────────
for arg in "$@"; do
  case "$arg" in
    -h|--help) usage; exit 0 ;;
    -*) echo "Error: Unknown option '$arg'"; echo "Run with --help for usage."; exit 1 ;;
    *) CHIP="$arg" ;;
  esac
done

# ── Check get-idf has been run ────────────────────────────────────────────────
if ! command -v idf.py &> /dev/null; then
  echo "Error: idf.py not found."
  echo "Run 'get-idf' first to activate the ESP-IDF environment."
  exit 1
fi

# ── Map chip to clangd target architecture ────────────────────────────────────
case "$CHIP" in
  esp32)            CLANGD_TARGET="xtensa-esp32-elf" ;;
  esp32s2)          CLANGD_TARGET="xtensa-esp32s2-elf" ;;
  esp32s3)          CLANGD_TARGET="xtensa-esp32s3-elf" ;;
  esp32c3|esp32c6|esp32h2) CLANGD_TARGET="riscv32-esp-elf" ;;
  *)
    echo "Error: Unknown chip '$CHIP'."
    echo "Supported: esp32, esp32s2, esp32s3, esp32c3, esp32c6, esp32h2"
    exit 1
    ;;
esac

echo "Bootstrapping ESP-IDF project for $CHIP..."

# ── .clangd ───────────────────────────────────────────────────────────────────
if [ -f ".clangd" ]; then
  echo "  [skip] .clangd already exists"
else
  cat > .clangd << EOF
CompileFlags:
  CompilationDatabase: build/
  Add:
    - --target=$CLANGD_TARGET
    - -fno-builtin-memcpy
EOF
  echo "  [ok]   .clangd created ($CLANGD_TARGET)"
fi

# ── .gitignore ────────────────────────────────────────────────────────────────
if [ -f ".gitignore" ]; then
  echo "  [skip] .gitignore already exists"
else
  cat > .gitignore << 'EOF'
# ESP-IDF build output
build/

# Dependency manager
dependencies.lock
managed_components/

# Chip config — uncomment to ignore (useful if team members use different chips)
# sdkconfig
sdkconfig.old
EOF
  echo "  [ok]   .gitignore created"
fi

# ── idf.py set-target ────────────────────────────────────────────────────────
echo "  [..] Running idf.py set-target $CHIP"
if ! idf.py set-target "$CHIP" 2>&1; then
  echo "Error: idf.py set-target failed. Are you inside an ESP-IDF project directory?"
  exit 1
fi
echo "  [ok]   set-target complete"

# ── idf.py build ─────────────────────────────────────────────────────────────
echo "  [..] Running idf.py build (generates compile_commands.json for clangd)"
if ! idf.py build 2>&1; then
  echo "Error: idf.py build failed. Check the output above for details."
  exit 1
fi
echo "  [ok]   build complete"

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "Done. Open any .c file in Neovim — clangd is ready."
