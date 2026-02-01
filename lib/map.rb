class Map
    TILE_SIZE = 32
    MAP_LENGTH = 128
    ENNEMIES = 30

    attr_reader :scene, :ennemies

    def initialize(scene, floor)
        @scene = scene
        @floor = floor

        @road_tiles = []
        load_road_tiles

        # to contain snow that will be collected 
        @snow_tiles = []
        generate_snow_tiles(MAP_LENGTH)

        @ennemies = []
        generate_ennemies
    end

    def load_road_tiles
        last_tile = nil
        @road_tileset = Gosu::Image.load_tiles('gfx/road_tiles.png', 128, 96, { retro: true, tileable: true })
        ((MAP_LENGTH * TILE_SIZE) / 128).floor.times do |x|
            tile = Gosu.random(0, 10).floor < 2 ? 1 : 0

            # to prevent two pedestrian walkways next to each other
            tile = 0 if last_tile == 1
            last_tile = tile

            @road_tiles.push [x * 128, tile]
        end

        # interface
        @interface = Gosu::Image.new('gfx/interface.png', retro: true)
        @goal = Gosu::Image.new('gfx/goal.png', retro: true)
    end

    def generate_ennemies
        beginning = 10 # distance to understand the mechanics
        distance_between_ennemies = (((MAP_LENGTH - beginning) * TILE_SIZE) / ENNEMIES).floor
        x = TILE_SIZE * beginning
        ENNEMIES.times do
            x += distance_between_ennemies
            y = Gosu.random(10, 50)
            @ennemies.push Ennemy.new(self, x, y)
        end
    end

    def get_perspective(position_x, position_y, size)
        horizon_y = 100
        first_plan_y = @floor
        scale_min = 0.4
        scale_max = 1.0

        ratio = ((position_y - horizon_y) / (first_plan_y - horizon_y)).clamp(0.0, 1.0)
        return (scale_min + (scale_max - scale_min) * (ratio * ratio)).round(3)
    end

    def update(hero, snowball, dt)
        # is snowball should be fed with snow_tiles ?
        if snowball.hero_push?
            @snow_tiles.each do |snow_tile|
                if snow_tile.feeds_snowball?(snowball)
                    break 
                end
            end

            @snow_tiles.delete_if {|snow_tile| return snow_tile.to_delete?}
        end

        # ennemies
        @ennemies.each {|ennemy| ennemy.update(dt)}

        # has hero reached the end ?
        if snowball.center_x + snowball.radius >= MAP_LENGTH * TILE_SIZE
            $score = snowball.radius
            @scene.window.switch_scene(:victory)
        end
    end

    def generate_snow_tiles(qty)
        qty.times { add_snow_tile }
    end

    def add_snow_tile
        x, y, amount = @snow_tiles.size * TILE_SIZE, @floor, 4
        @snow_tiles.push SnowTile.new(self, x, y, amount)
    end

    def draw
        draw_sky
        draw_floor
        @snow_tiles.each {|snow_tile| snow_tile.draw}
        @ennemies.each {|ennemy| ennemy.draw}
    end

    def draw_sky
        color = Gosu::Color.new(255, 8, 112, 151)
        Gosu.draw_rect(-@scene.window.width, -@scene.window.height, @scene.window.width * 2 + MAP_LENGTH * TILE_SIZE, @scene.window.height * 2, color)
    end

    def draw_floor
        @interface.draw(-@interface.width, -62, 1000)
        @goal.draw(MAP_LENGTH * TILE_SIZE, -62, 1000)

        @road_tiles.each do |x, tile|
            @road_tileset[tile].draw(x, @floor, 10)
        end
    end
end