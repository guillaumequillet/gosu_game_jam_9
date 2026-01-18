=begin
    the snow that is contained on a single tile
=end

class SnowTile
    attr_reader :amount
    def initialize(x, y, amount)
        @x, @y, @amount = x, y, amount
        @to_delete = false
    end

    def feeds_snowball?(snowball)
        left = snowball.center_x - snowball.size / 2
        return (left >= @x && left <= @x + Map::TILE_SIZE)
    end

    def draw
        Gosu.draw_rect(@x, @y - @amount, Map::TILE_SIZE, @amount, Gosu::Color::WHITE)
    end
end