# You should run this from the riscv-arch-test repo

set -e
ELF="$1"

HEX="$(mktemp -p ./ --suffix=.hex)"

cleanup() {
    rm -f "$HEX"
}
trap cleanup EXIT

riscv64-unknown-elf-objcopy -O verilog --verilog-data-width=4 "$ELF" "$HEX"

./config/cores/bonato/bonato-2/Vtb_data_path.exe +PROGRAM="$HEX"
