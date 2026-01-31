class Map
    TILE_SIZE = 32
    MAP_LENGTH = 64

    def initialize(floor)
        @floor = floor

        # we'll load some map from Tiled later
        @tiles = []
        
        # to contain snow that will be collected 
        @snow_tiles = []
        generate_snow_tiles(MAP_LENGTH)
    end

    def get_perspective(position_x, position_y, size)
        horizon_y = 100
        first_plan_y = @floor
        scale_min = 0.6
        scale_max = 1.0

        ratio = ((position_y - horizon_y) / (first_plan_y - horizon_y)).clamp(0.0, 1.0)
        return (scale_min + (scale_max - scale_min) * (ratio * ratio)).round(3)
    end

    def update(hero, snowball)
        # is snowball should be fed with snow_tiles ?
        if snowball.hero_push?
            @snow_tiles.each do |snow_tile|
                if snow_tile.feeds_snowball?(snowball)
                    break 
                end
            end

            @snow_tiles.delete_if {|snow_tile| return snow_tile.to_delete?}
        end
    end

    def generate_snow_tiles(qty)
        qty.times { add_snow_tile }
    end

    def add_snow_tile
        x, y, amount = @snow_tiles.size * TILE_SIZE, @floor, 4
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