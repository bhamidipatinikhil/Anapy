import sys
sys.path.append('/home/nikhil/Documents/Nikhil Programming/MCA 4th Sem Project/Anapy/Manimations')
from AnimArray import *

class Rough(Scene):
    def construct(self):
        anim_arr = AnimArray("arr", [6, 7, 8, 17, 3]).shift(LEFT*3)
        self.play(Create(anim_arr))
        self.wait(1)
        self.play(anim_arr.append(9))
        self.wait(1)
        self.play(anim_arr.append(472))
        self.play(anim_arr.insert(1, 5))
        self.wait(1)
        self.play(anim_arr.insert(3, 4))
        self.wait(1)
        self.play(anim_arr.pop(2))
        self.wait(1)
        self.play(anim_arr.pop(4))
        self.wait(1)
        self.play(anim_arr.pop(2))
        self.play(anim_arr.pop(1))
        self.play(anim_arr.pop(1))
        self.wait(1)

        