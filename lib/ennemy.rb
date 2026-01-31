class Ennemy
    Z_ORDER = 5

    def initialize(map, x, y)
        @map = map
        @x, @y = x, y    
        @width = 32
        @height = 32
        @scale = @map.get_perspective(@x, @y, @width)

        # projectile
        @cooldown = 1000
        @cooldown_tick = Gosu.milliseconds - Gosu.random(0, @cooldown)
        @speed = 0.8
        @ko = false
    end
    
    def update(dt)
        unless @ko
            if Gosu.milliseconds - @cooldown_tick >= @cooldown
                throw_ball
                @cooldown_tick = Gosu.milliseconds
            end
        end
    end

    def throw_ball
        target_x = @map.scene.snowball.center_x
        target_y = @map.scene.snowball.center_y - @map.scene.snowball.radius
        projectile = Projectile.new(@map, @x, @y, target_x, target_y, @speed)
        @map.scene.add_projectile(projectile)
        @map.scene.play_sound(:throw, 0.2)
    end

    def hit?(x, y, w, h)
        return x >= @x - (@width * @scale) / 2 && x + w >= @x + (@width * @scale) / 2 && y >= @y - (@height * @scale) / 2 && y <= @y + (@height * @scale) / 2
    end

    def hit!
        @ko = true
        p 'hit !'
    end

    def draw
        Gosu.draw_rect(@x - @width * @scale / 2, @y - @height * @scale / 2, @width * @scale, @height * @scale, Gosu::Color::RED)
    end
end