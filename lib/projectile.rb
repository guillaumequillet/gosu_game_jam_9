class Projectile
    attr_reader :x, :y
    IMAGE = Gosu::Image.new('gfx/projectile.png', retro: true)
    Z_ORDER = 4

    def initialize(map, source_x, source_y, dest_x, dest_y, speed, from = :ennemy)
        @map = map
        @x, @y = source_x, source_y
        @angle = Gosu.angle(source_x, source_y, dest_x, dest_y)
        @speed = speed
        @size = IMAGE.width * 2
        @from = from
        @to_destroy = false
        @last_positions = []
        @max_last_positions = 20
    end

    def update(dt)
        @x += Gosu.offset_x(@angle, @speed * dt)
        @y += Gosu.offset_y(@angle, @speed * dt)
        @scale = @map.get_perspective(@x, @y, @size)

        # we test collisions against each ennemy
        if @from == :hero
            @map.ennemies.select {|e| !e.ko}.each do |ennemy|
                if ennemy.hit?(@x, @y, (@size * @scale) / 2.0)
                    @to_destroy = true # we mark the projectile as to destroy
                    ennemy.hit! # we hit the ennemy
                end
            end
        # we test collisions againt the snowball
        else
            if Gosu.distance(@x, @y, @map.scene.snowball.center_x, @map.scene.snowball.center_y) <= @map.scene.snowball.radius + ((@size * @scale) / 2.0)
                @map.scene.snowball.hit! # we hit the snowball
                @to_destroy = true # we mark the projectile as to destroy
            end
        end

        # last_positions
        @last_positions.shift if @last_positions.size > @max_last_positions
        
        @last_positions.push [@x, @y, @scale]
    end

    def outside?(camera)
        return (@y >= 1000 || @y <= -1000 || @to_destroy)
    end

    def draw
        @last_positions.each_with_index do |last_position, i|
            x, y, scale = *last_position
            alpha = ((255 / @last_positions.size * 0.3) * i).floor
            alpha = 255 if i == @last_positions.size - 1
            color = Gosu::Color.new(alpha, 255, 255, 255)
            IMAGE.draw_rot(x, y, Z_ORDER, 0, 0.5, 0.5, scale, scale, color)
        end
    end
end