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
    end

    def update
        case @scene.class.to_s
        when 'SceneTitle'

        when 'SceneGame'

        when 'SceneGameOver'

        end
    end

    def draw
        case @scene.class.to_s
        when 'SceneTitle'
            @font.draw_text('TITLE SCREEN', 50, 50, 0)
        when 'SceneGame'
            @font.draw_text('GAME SCREEN', 50, 50, 0)
        when 'SceneGameOver'
            @font.draw_text('GAME OVER', 50, 50, 0)
        end
    end
end

Window.new.show