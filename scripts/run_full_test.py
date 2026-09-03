import subprocess
import os
import sys

asm_dir = "asm"
tb_dir = "testbenches"
build_dir = "build"
mem_dir = "mem"

def run_full_test(testfile):
    if not testfile.endswith("_tb.v"):
        sys.exit(f"Error: expected a _tb.v file, got {testfile}")

    root = testfile.removesuffix("_tb.v")
    asm_file = root + ".s"
    
    tb_path = os.path.join(tb_dir, testfile)
    asm_path = os.path.join(asm_dir, asm_file)
    o_path = os.path.join(build_dir, root + ".o")
    elf_path = os.path.join(build_dir, root + ".elf")
    hex_path = os.path.join(mem_dir, root + ".hex")

    if not os.path.exists(tb_path):
        sys.exit(f"Error: testbench not found: {tb_path}")

    if not os.path.exists(asm_path):
        sys.exit(f"Error: assembly file not found: {asm_path}")

    subprocess.run(["riscv64-unknown-elf-as", "-march=rv32i", "-mabi=ilp32", "-o", o_path, asm_path], check=True)
    subprocess.run(["riscv64-unknown-elf-ld", "-melf32lriscv", "-nostdlib", "-T", "asm/link.ld", "-o", elf_path, o_path], check=True)
    subprocess.run(["riscv64-unknown-elf-objcopy", "-O", "verilog", elf_path, hex_path], check=True)

    subprocess.run(["py", "scripts/b2w.py", hex_path, hex_path], check=True)
    subprocess.run(["py", "scripts/top_level_test.py", tb_path], check=True)

if __name__ == "__main__":
    run_full_test(sys.argv[1])

        
