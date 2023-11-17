import sys
sys.path.append('/home/nikhil/Documents/Nikhil Programming/MCA 4th Sem Project/Anapy/Manimations')
from AnimVariable import *

class Test(Scene):
    def construct(self):
        count = AnimVariable("count", Text(str(0)))
        
        self.play(Create(count))
        self.wait(1)
        
        count.update_value_2(Text(str(1)))
        self.wait(1)
        
        count.update_value_2(Text(str(1)))
        self.wait(1)

        count.update_value_2(Text(str(1)))
        self.wait(1)

        count.update_value_2(Text(str(1)))
        self.wait(1)

        
        