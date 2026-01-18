class Map
    def initialize(floor)
        @floor = floor

        # we'll load some map from Tiled later
        @tiles = []
        
        # to contain snow that will be collected 
        @snow_tiles = []
    end

    def update(hero, snowball)

    end

    def draw
        draw_floor
        @snow_tiles.each {|snow_tile| snow_tile.draw}
    end

    def draw_floor
        Gosu.draw_rect(0, @floor, 640, 480 - @floor, Gosu::Color::BLUE)
    end
end