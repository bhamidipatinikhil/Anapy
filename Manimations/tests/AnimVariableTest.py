import sys
sys.path.append('..')
from AnimVariable import *

class Test(Scene):
    def construct(self):
        av = AnimVariable("count", Text(str(0)))
        self.play(Create(av))
        self.wait(1)
        k=6
        for i in range(7):
            # self.play(av.update_value_2(k))
            av.update_value_2(Text(str(k)))
            self.wait(1)
            k+=1
        self.play(av.animate.shift(UP))
        self.wait(2)
        
        