class Projectile
    attr_reader :x, :y
    IMAGE = Gosu::Image.new('gfx/projectile.png', retro: true)
    Z_ORDER = 4

    def initialize(map, source_x, source_y, dest_x, dest_y, speed, from = :ennemy)
        @map = map
        @x, @y = source_x, source_y
        @angle = Gosu.angle(source_x, source_y, dest_x, dest_y)
        @speed = speed
        @size = IMAGE.width
        @from = from
        @to_destroy = false
    end

    def update(dt)
        @x += Gosu.offset_x(@angle, @speed * dt)
        @y += Gosu.offset_y(@angle, @speed * dt)
        @scale = @map.get_perspective(@x, @y, @size)

        # we test collisions against each ennemy
        if @from == :hero
            @map.ennemies.each do |ennemy|
                if ennemy.hit?(x, y, w, h)
                    x, y = @x, @y
                    w, h = @scale * IMAGE.width, @scale * IMAGE.height
                    @to_destroy = true
                    ennemy.hit!
                end
            end
        # we test collisions againt the snowball
        else
            if Gosu.distance(@x, @y, @map.scene.snowball.center_x, @map.scene.snowball.center_y) <= @map.scene.snowball.radius
                @map.scene.snowball.hit!
                @to_destroy = true
            end
        end
    end

    def outside?(camera)
        return (@y >= 1000 || @y <= -1000 || @to_destroy)
    end

    def draw
        IMAGE.draw_rot(@x, @y, Z_ORDER, 0, 0.5, 0.5, @scale, @scale)
    end
end