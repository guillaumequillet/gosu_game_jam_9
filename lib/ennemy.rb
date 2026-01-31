class Ennemy
    Z_ORDER = 5

    attr_reader :ko

    def initialize(map, x, y)
        @map = map
        @x, @y = x, y    
        @width = 32
        @height = 32
        @scale = @map.get_perspective(@x, @y, @width)

        # projectile
        @cooldown = Gosu.random(1000, 2000)
        @cooldown_tick = Gosu.milliseconds - Gosu.random(0, @cooldown) # to randomize the beginning of the attack
        @range = 300
        @speed = 0.7
        @ko = false
    end
    
    def update(dt)
        unless @ko
            if (Gosu.distance(@x, @y, @map.scene.snowball.center_x, @map.scene.snowball.center_y) - @map.scene.snowball.radius <= @range) && (Gosu.milliseconds - @cooldown_tick >= @cooldown)
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

    def hit?(x, y, radius)
        radius2 = [@width, @height].max / 2.0
        return Gosu.distance(@x, @y, x, y) <= (radius + radius2) 
    end

    def hit!
        # hit point
        @map.scene.attack_effect(@x, @y)
        @map.scene.play_sound(:hit, 0.4, 0.7)
        @ko = true
    end

    def draw
        color = @ko ? Gosu::Color::RED : Gosu::Color::GREEN
        Gosu.draw_rect(@x - @width * @scale / 2, @y - @height * @scale / 2, @width * @scale, @height * @scale, color)
    end
end