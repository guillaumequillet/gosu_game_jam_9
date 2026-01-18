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
        @snowball = Snowball.new(64, @floor, 32)
    end

    def update(dt)
        @hero.update(dt, @snowball)
        @snowball.update(dt)
        @map.update(@hero, @snowball)
    end

    def draw
        @hero.draw
        @snowball.draw
        @map.draw
    end
end