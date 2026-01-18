class Snowball
    Z_ORDER = 3

    attr_reader :center_x, :size
    def initialize(center_x = 0, center_y = 0)
        @min_radius, @max_radius = 8, 80
        @center_x, @center_y, @radius = center_x, center_y, @min_radius
        @angle = 0
        @speed = 0
        @speed_sign = nil
        @hero_push = false
        @gfx = Gosu::Image.new('gfx/snowball.png', retro: true)
        calculate_size
    end

    def button_down(id)
    
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
    
    def lerp(a, b, t)
        a + (b - a) * t
    end

    def calculate_size
        @scale = (@radius * 2) / @gfx.width.to_f
        @size = @scale * @gfx.width
        @offset_y = 0.5 * @size
    end

    def update(dt)
        # dimension
        calculate_size

        # movement
        @center_x += @speed
        @angle += @speed * 0.8
    end

    def draw
        @gfx.draw_rot(@center_x, @center_y - @offset_y, Z_ORDER, @angle, 0.5, 0.5, @scale, @scale)
    end
end