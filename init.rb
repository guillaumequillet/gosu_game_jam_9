require 'gosu'

Dir.glob("lib/*.rb").each {|fn| require_relative(fn)}

class Window < Gosu::Window
    def initialize
        super(640, 480, false)
        self.caption = 'Gosu Game Jam 9'
        @scene = SceneGame.new(self)
        @font = Gosu::Font.new(24)
    end

    def needs_cursor?; false; end

    def button_down(id)
        super
        close! if id == Gosu::KB_ESCAPE
        @scene.button_down(id)
    end

    def update
        @dt ||= Gosu.milliseconds
        dt = Gosu.milliseconds - @dt

        @scene.update(dt)

        @dt = Gosu.milliseconds
    end

    def draw
        @scene.draw
    end
end

Window.new.show