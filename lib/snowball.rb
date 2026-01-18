class Snowball
    def initialize(center_x = 0, center_y = 0, radius = 0)
        @center_x, @center_y, @radius = center_x, center_y, radius
        @angle = 0
        @gfx = Gosu::Image.new('gfx/snowball.png', retro: true)
    end

    def button_down(id)
    
    end

    def update(dt)
        @scale = @radius.to_f / @gfx.width
        @offset_y = 0.5 * (@scale * @gfx.height)
    end

    def draw
        @gfx.draw_rot(@center_x, @center_y - @offset_y, 0, @angle, 0.5, 0.5, @scale, @scale)
    end
end