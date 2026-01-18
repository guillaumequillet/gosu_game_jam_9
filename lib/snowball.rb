class Snowball
    attr_reader :center_x, :size
    def initialize(center_x = 0, center_y = 0, radius = 0)
        @center_x, @center_y, @radius = center_x, center_y, radius
        @angle = 0
        @speed = 0
        @hero_push = false
        @gfx = Gosu::Image.new('gfx/snowball.png', retro: true)
        calculate_size
    end

    def button_down(id)
    
    end

    def collides_hero?(push_x)
        return push_x >= (@center_x - (@scale * @gfx.width * 0.5))
    end

    def hero_push(speed)
        @hero_push = true 
        @speed = speed
    end

    def slowdown
        @hero_push = false
        @speed *= 0.75
        @speed = 0 if @speed < 0
    end
    
    def calculate_size
        @scale = @radius.to_f / @gfx.width
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
        @gfx.draw_rot(@center_x, @center_y - @offset_y, 0, @angle, 0.5, 0.5, @scale, @scale)
    end
end