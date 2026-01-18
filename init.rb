require 'gosu'

class Window < Gosu::Window
    def initialize
        super(640, 480, false)
        self.caption = 'Gosu Game Jam 9'
    end

    def needs_cursor?; false; end

    def button_down(id)
        super
        close! if id == Gosu::KB_ESCAPE
    end

    def update

    end

    def draw

    end
end

Window.new.show