from manim import *
from DescrRectangle import *

class AnimVariable(VMobject):
    def __init__(self, name, value_mobject, **kwargs):
        super().__init__(**kwargs)
        self.name = name
        self.value_mobject = value_mobject
        self.name_block = DescrRectangle(Text(self.name)).shift(LEFT)
        self.value_block = DescrRectangle(value_mobject).shift(RIGHT)
        self.add(self.name_block, self.value_block)

    def update_value(self, new_mobject):
        self.remove(self.value_block)
        self.value_block = DescrRectangle(Text(new_mobject)).shift(RIGHT)
        self.add(self.value_block)
        return AnimationGroup(
            
        )
    
    def update_value_2(self, new_mobject):
        self.value_block.update_value_2(new_mobject).shift(RIGHT)
        return AnimationGroup(
            
        )