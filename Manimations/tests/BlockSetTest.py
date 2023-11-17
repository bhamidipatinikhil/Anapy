import sys
sys.path.append('..')
from BlockSet import *

class Rough(Scene):
    def construct(self):
        bs = BlockSet([6, 7, 8, 17, 3]).shift(LEFT*3)
        self.play(Create(bs))
        self.wait(1)
        self.play(bs.append(9))
        self.wait(1)
        self.play(bs.append(472))
        self.play(bs.insert(1, 5))
        self.wait(1)
        self.play(bs.insert(3, 4))
        self.wait(1)
        self.play(bs.pop(2))
        self.wait(1)
        self.play(bs.pop(4))
        self.wait(1)
        self.play(bs.pop(2))
        self.play(bs.pop(1))
        self.play(bs.pop(1))
        self.wait(1)