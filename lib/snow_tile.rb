class SnowTile
    Z_ORDER = 2
    TEXTURE = Gosu::Image.load_tiles('gfx/snow_tiles.png', 32, 32, retro: true)
    
    attr_reader :amount
    def initialize(x, y, amount)
        amount = amount.clamp(0, TEXTURE.size)
        @x, @y, @amount = x, y, amount
    end

    def to_delete?
        return (@amount <= 0)
    end

    def feeds_snowball?(snowball)
        left = snowball.center_x - snowball.size / 8
        if (left >= @x && left <= @x + Map::TILE_SIZE)
            amount = @amount * 0.1
            @amount -= amount
            @amount = 0 if @amount <= 0
            snowball.feed(amount * 2.0)
        else 
            return false
        end
    end

    def draw
        TEXTURE[@amount - 1].draw(@x, @y - 0.5 * TEXTURE[0].height, Z_ORDER)
    end
end