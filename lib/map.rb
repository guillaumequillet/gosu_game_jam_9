class Map
    def initialize
        # we'll load some map from Tiled later
        @tiles = []
        
        # to contain snow that will be collected 
        @snow_tiles = []
    end

    def update

    end

    def draw
        @snow_tiles.each {|snow_tile| snow_tile.draw}
    end
end