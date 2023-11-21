import os
import sys

filename = sys.argv[1]

os.system(f"truncate -s 0 manim-output.py")
os.system(f"raku ./Anapy/anapy.raku {filename}")
os.system(f"manim -pql manim-output.py AnimationOutput")
# os.system(f"truncate -s 0 manim-output.py")
