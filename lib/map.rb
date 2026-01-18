class Map
    TILE_SIZE = 32

    def initialize(floor)
        @floor = floor

        # we'll load some map from Tiled later
        @tiles = []
        
        # to contain snow that will be collected 
        @snow_tiles = []
        generate_snow_tiles(10)
    end

    def update(hero, snowball)
        # is snowball should be fed with snow_tiles ?


    end

    def generate_snow_tiles(qty)
        qty.times { add_snow_tile }
    end

    def add_snow_tile
        x, y, amount = @snow_tiles.size * TILE_SIZE, @floor, Gosu.random(2, 6)
        @snow_tiles.push SnowTile.new(x, y, amount)
    end

    def draw
        draw_floor
        @snow_tiles.each {|snow_tile| snow_tile.draw}
    end

    def draw_floor
        Gosu.draw_rect(0, @floor, 640, 480 - @floor, Gosu::Color::BLUE)
    end
end