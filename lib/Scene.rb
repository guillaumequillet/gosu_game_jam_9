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
    attr_reader :map

    def initialize(window)
        super(window)
        @floor = @window.height / 1.5

        @map = Map.new(@floor)
        @hero = Hero.new(self, 32, @floor)
        @camera = Camera.new(@window, @hero)
        @snowball = Snowball.new(100, @floor)
        @snow = Snow.new(window, @hero)
        @projectiles = []
    end

    def button_down(id)
        @hero.button_down(id)
    end

    def add_projectile(projectile)
        @projectiles.push projectile
    end

    def update(dt)
        @hero.update(dt, @snowball)
        @camera.update(dt)
        @snowball.update(dt)
        @map.update(@hero, @snowball, dt)
        @snow.update(dt)

        @projectiles.each {|projectile| projectile.update(dt)}
        @projectiles.delete_if {|projectile| projectile.outside?(@camera)}

        @window.caption = @projectiles.size
    end

    def draw
        @camera.look do
            @hero.draw
            @snowball.draw
            @map.draw
            @projectiles.each {|projectile| projectile.draw}
            @snow.draw
        end
    end
end