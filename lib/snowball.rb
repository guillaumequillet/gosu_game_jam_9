class Snowball
    Z_ORDER = 3

    attr_reader :center_x, :center_y, :radius, :max_radius, :size
    def initialize(scene, center_x = 0, center_y = 0)
        @scene = scene
        @min_radius, @max_radius = 64, 96
        @attack_radius = 4
        @center_x, @center_y, @radius = center_x, center_y, @min_radius
        @angle = 0
        @speed = 0
        @melting_speed = 0.005
        @speed_sign = nil
        @hero_push = false
        @gfx = Gosu::Image.new('gfx/snowball.png', retro: true)
        @max_gfx = Gosu::Image.new('gfx/max.png', retro: true)
        calculate_size
    end

    def collides_hero?(push_x)
        tolerance = @size * 0.3
        return (push_x >= @center_x - tolerance && push_x <= @center_x + tolerance)
    end

    def hero_push(speed)
        @hero_push = true 
        @speed = speed
        @speed_sign = (@speed >= 0) ? :plus : :minus
    end

    def hero_push?
        return @hero_push
    end

    def feed(amount)
        if (@radius + amount) > @max_radius
            amount = @max_radius - @radius
        end

        @radius += amount
        @center_x += amount
        calculate_size
    end

    def slowdown
        @hero_push = false
        
        if @speed != 0.0
            if @speed_sign == :plus
                @speed = lerp(@speed, 0, 0.06)
                @speed = 0 if @speed <= 0.01
            elsif @speed_sign == :minus
                @speed = lerp(@speed, 0, 0.06)
                @speed = 0 if @speed > -0.01
            end
        end
    end
    
    def hit!
        # hit point
        target_x = @center_x
        target_y = @center_y - @radius
        @scene.attack_effect(target_x, target_y)

        # reduce size if > min
        @radius -= @attack_radius
        @radius = @radius.clamp(0, @max_radius)
        calculate_size

        @scene.play_sound(:hit, 0.4, 0.7)

        if @radius <= 0
            @scene.game_over
        end
    end

    def lerp(a, b, t)
        a + (b - a) * t
    end

    def calculate_size
        @scale = (@radius * 2) / @gfx.width.to_f
        @size = @scale * @gfx.width
        @offset_y = 0.5 * @size
    end

    def update(dt)
        # melting if not moving
        # @radius -= @melting_speed * dt if @speed == 0
        @scene.game_over if @radius <= 0

        # dimension
        calculate_size

        # movement
        @center_x += @speed
        @angle += @speed * 0.8

        if @center_x - @radius < 0
            @center_x = 0 + @radius
            @angle = 0
        end
    end

    def draw
        @gfx.draw_rot(@center_x, @center_y - @offset_y, Z_ORDER, @angle, 0.5, 0.5, @scale, @scale)
        @max_gfx.draw_rot(@center_x, @center_y - @offset_y, Z_ORDER, 0, 0.5, 0.5) if @radius == @max_radius
    end
end