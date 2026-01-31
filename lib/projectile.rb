class Projectile
    attr_reader :x, :y
    IMAGE = Gosu::Image.new('gfx/projectile.png', retro: true)
    Z_ORDER = 4

    def initialize(map, source_x, source_y, dest_x, dest_y, speed)
        @map = map
        @x, @y = source_x, source_y
        @angle = Gosu.angle(source_x, source_y, dest_x, dest_y)
        @speed = speed
        @size = IMAGE.width
    end

    def update(dt)
        @x += Gosu.offset_x(@angle, @speed * dt)
        @y += Gosu.offset_y(@angle, @speed * dt)
        @scale = @map.get_perspective(@x, @y, @size)
    end

    def outside?(camera)
        return false # temp
        return (@x >= camera.x + camera.window.width / 2) || (@x <= camera.x - camera.window.width / 2) || (@y >= camera.y + camera.window.height / 2) || (@y <= camera.y - camera.window.height / 2)
    end

    def draw
        IMAGE.draw_rot(@x, @y, Z_ORDER, 0, 0.5, 0.5, @scale, @scale)
    end
end