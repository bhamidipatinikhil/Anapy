from manim import *
import sys
sys.path.append("./Manimations")
from Manimations.AnimArray import *
from Manimations.AnimVariable import *
from Manimations.BlockSet import *
from Manimations.DescrRectangle import *

class AnimationOutput(Scene):
    def construct(self):


        arr = AnimArray("arr", [6, 7, 8, 17, 3, ]).shift(LEFT*3)
        self.play(Create(arr))
        self.wait(1)
        self.play(arr.append(9))
        self.wait(1)
        self.play(arr.append(472))
        self.wait(1)
        self.play(arr.insert(1, 5))
        self.wait(1)
        self.play(arr.insert(3, 4))
        self.wait(1)
        self.play(arr.pop(2))
        self.wait(1)
        self.play(arr.pop(4))
        self.wait(1)
        self.play(arr.pop(2))
        self.wait(1)
        self.play(arr.pop(1))
        self.wait(1)
        self.play(arr.pop(1))
        self.wait(1)