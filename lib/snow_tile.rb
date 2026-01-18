=begin
    the snow that is contained on a single tile
=end

class SnowTile
    attr_reader :amount
    def initialize(x, y, amount)
        @x, @y, @amount = x, y, amount
    end

    def to_delete?
        return (@amount <= 0)
    end

    def feeds_snowball?(snowball)
        left = snowball.center_x - snowball.size / 2
        if (left >= @x && left <= @x + Map::TILE_SIZE)
            amount = @amount * 0.2
            @amount -= amount
            @amount = 0 if @amount <= 0
            snowball.feed(amount * 0.5)
        else 
            return false
        end
    end

    def draw
        Gosu.draw_rect(@x, @y - @amount, Map::TILE_SIZE, @amount, Gosu::Color::WHITE)
    end
end