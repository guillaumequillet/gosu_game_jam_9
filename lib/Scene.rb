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
        @map = Map.new
        @hero = Hero.new
        @snowball = Snowball.new
    end

    def update(dt)
        @hero.update(dt)
        @snowball.update(dt)
        @map.update(@hero, @snowball)
    end

    def draw
        @font.draw_text('GAME SCREEN', 50, 50, 0)
    end
end