class Scene
    def initialize(window)
        @window = window
        @font = Gosu::Font.new(24)
    end

    def button_down(id)

    end

    def update(dt)

    end

    def draw

    end
end

class SceneTitle < Scene
    def draw
        @font.draw_text('TITLE SCREEN', 50, 50, 0)
    end
end

class SceneGameOver < Scene
    def draw
        @font.draw_text('GAME OVER SCREEN', 50, 50, 0)
    end
end

class SceneGame < Scene
    def initialize(window)
        super(window)
        @floor = @window.height / 1.5

        @map = Map.new(@floor)
        @hero = Hero.new(32, @floor)
        @camera = Camera.new(@window, @hero)
        @snowball = Snowball.new(100, @floor)
        @snow = Snow.new(window, @hero)
    end

    def update(dt)
        @hero.update(dt, @snowball)
        @camera.update(dt)
        @snowball.update(dt)
        @map.update(@hero, @snowball)
        @snow.update(dt)
    end

    def draw
        @camera.look do
            @hero.draw
            @snowball.draw
            @map.draw
            @snow.draw
        end
    end
end