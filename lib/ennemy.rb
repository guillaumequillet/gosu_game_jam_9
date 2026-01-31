class Ennemy
    Z_ORDER = 5

    def initialize(map, x, y)
        @map = map
        @x, @y = x, y    
        @width = 32
        @height = 32
        @scale = @map.get_perspective(@x, @y, @width)
    end

    def update(dt)

    end

    def hit?

    end

    def draw
        Gosu.draw_rect(@x - @width * @scale / 2, @y - @height * @scale / 2, @width * @scale, @height * @scale, Gosu::Color::RED)
    end
end