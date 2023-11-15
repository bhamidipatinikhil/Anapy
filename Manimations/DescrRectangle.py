from manim import *

class DescrRectangle(VMobject):
    def __init__(self, value_mobject, width=2, height=1, **kwargs):
        super().__init__(**kwargs)
        
        self.rect = Rectangle(width=width, height=height)
        self.value_mobject = value_mobject
        if(self.value_mobject.width > self.value_mobject.height):
            self.value_mobject.scale_to_fit_width(width)
        else:
            self.value_mobject.scale_to_fit_height(height)
        self.value_mobject.scale(0.55)
        self.width = self.value_mobject.width
        self.height = self.value_mobject.height
        self.add(self.rect, self.value_mobject)

    def set_width(self,width):
        prev_posn = self.value_mobject.get_left()
        self.rect.stretch_to_fit_width(width*1.5)
        self.rect.next_to(prev_posn, RIGHT, buff=0.0)
        # self.rect.shift(RIGHT*(width))


    def update_value_2(self, new_value_mobject):
        self.remove(self.value_mobject)
        self.value_mobject = new_value_mobject
        if(self.value_mobject.width > self.value_mobject.height):
            self.value_mobject.scale_to_fit_width(self.width)
        else:
            self.value_mobject.scale_to_fit_height(self.height)
        self.value_mobject.scale(0.55)
        self.add(self.value_mobject)
        return self.value_mobject