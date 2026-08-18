import subprocess
import os
import sys

def run_full_test(testfile):
    if not testfile.endswith("_tb.v"):
        sys.exit(f"Error: expected a _tb.v file, got {testfile}")

        root = testfile.removesuffix("_tb.v")
        asm_file = root + "_test.s"

        
