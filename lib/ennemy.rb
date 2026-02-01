class Ennemy
    SCORE = 100
    Z_ORDER = 5

    attr_reader :ko

    def initialize(map, x, y)
        @map = map
        @x, @y = x, y    
        @width = 128
        @height = 128
        @scale = @map.get_perspective(@x, @y, @width)

        @sprites = Gosu::Image.load_tiles('gfx/ennemy.png', @width, @height, retro: true)

        # projectile
        @cooldown = Gosu.random(200, 600)
        @cooldown_tick = Gosu.milliseconds
        @range = 400
        @speed = 0.7
        @ko = false
        @throwing = false
        @throwing_tick = nil
        @throwing_duration = 300
    end
    
    def update(dt)
        unless @ko
            if !@throwing && (Gosu.distance(@x, @y, @map.scene.snowball.center_x, @map.scene.snowball.center_y) <= @range) && (Gosu.milliseconds - @cooldown_tick >= @cooldown)
                throw_ball
                @cooldown = Gosu.random(200, 600)
                @cooldown_tick = Gosu.milliseconds
            end

            # animation
            if @throwing && Gosu.milliseconds - @throwing_tick >= @throwing_duration
                @throwing = false
            end
        end
    end

    def throw_ball
        target_x = @map.scene.snowball.center_x
        target_y = @map.scene.snowball.center_y - @map.scene.snowball.radius
        projectile = Projectile.new(@map, @x, @y, target_x, target_y, @speed)
        @map.scene.add_projectile(projectile)
        @map.scene.play_sound(:throw, 0.2)

        @throwing = true
        @throwing_tick = Gosu.milliseconds
    end

    def hit?(x, y, radius)
        radius2 = [@width, @height].max / 2.0
        return Gosu.distance(@x, @y, x, y) <= (radius + radius2) 
    end

    def hit!
        # hit point
        @map.scene.attack_effect(@x, @y)
        @map.scene.play_sound(:hit, 0.8, 0.7)
        @ko = true
        $ennemy_score += SCORE
    end

    def draw
        frame = 0
        frame = 1 if @throwing
        frame = 2 if @ko

        @sprites[frame].draw(@x - @width * @scale / 2, @y - @height * @scale / 2, Z_ORDER, @scale, @scale)
        
        # color = @ko ? Gosu::Color::RED : Gosu::Color::GREEN
        # Gosu.draw_rect(@x - @width * @scale / 2, @y - @height * @scale / 2, @width * @scale, @height * @scale, color)
    end
end