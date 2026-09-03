import subprocess
import glob
import os
import sys

def top_level_test(testbench):
    src = glob.glob("src/*.v")
    testbench_file = os.path.basename(testbench)
    testbench_name = os.path.splitext(testbench_file)
    output = testbench_name[0].removesuffix("_tb")
    subprocess.run(["iverilog", "-o", "sim/" + output + ".vvp", testbench] + src, check=True)
    subprocess.run(["vvp", "sim/" + output + ".vvp"], check=True)
    subprocess.run(["gtkwave", "sim/" + output + ".vcd"], check=True)

if __name__ == "__main__":
    top_level_test(sys.argv[1])
