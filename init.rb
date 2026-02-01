require 'gosu'

Dir.glob("lib/*.rb").each {|fn| require_relative(fn)}

class Window < Gosu::Window
    def initialize
        super(640, 480, false)
        self.caption = 'Gosu Game Jam 9'
        @scene = SceneGame.new(self)
        @music = Gosu::Song.new('sfx/that-game-arcade-short-236108.mp3')
        @music.volume = 0.05
        @music.play(true)
    end

    def needs_cursor?; true; end

    def button_down(id)
        super
        close! if id == Gosu::KB_ESCAPE
        @scene.button_down(id)
    end

    def switch_scene(scene_type)
        @scene = case scene_type
        when :game then SceneGame.new(self) 
        when :victory then SceneVictory.new(self) 
        end
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