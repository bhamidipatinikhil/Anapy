from manim import *
import sys
sys.path.append("./Manimations")
from Manimations.AnimArray import *
from Manimations.AnimVariable import *
from Manimations.BlockSet import *
from Manimations.DescrRectangle import *

class AnimationOutput(Scene):
    def construct(self):


		count = AnimVariable("count", Text(str(0)))
		self.play(Create(count))
		self.wait(1)
		count.update_value_2(Text(str(1)))
		self.wait(1)
		count.update_value_2(Text(str(2)))
		self.wait(1)
		count.update_value_2(Text(str(6)))
		self.wait(1)