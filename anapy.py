import os
import sys

filename = sys.argv[1]

os.system(f"raku ./Anapy/anapy.raku {filename}")
# os.system(f"manim -pql manim-output.py AnimationOutput")
