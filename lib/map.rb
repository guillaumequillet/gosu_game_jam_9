class Map
    TILE_SIZE = 32
    MAP_LENGTH = 256
    ENNEMIES = 40

    attr_reader :scene, :ennemies

    def initialize(scene, floor)
        @scene = scene
        @floor = floor

        # we'll load some map from Tiled later
        @tiles = []
        
        # to contain snow that will be collected 
        @snow_tiles = []
        generate_snow_tiles(MAP_LENGTH)

        @ennemies = []
        generate_ennemies
    end

    def generate_ennemies
        beginning = 10 # distance to understand the mechanics
        distance_between_ennemies = (((MAP_LENGTH - beginning) * TILE_SIZE) / ENNEMIES).floor
        x = TILE_SIZE * beginning
        ENNEMIES.times do
            x += distance_between_ennemies
            y = Gosu.random(0, 150)
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
        Gosu.draw_rect(0, @floor, 640, 480 - @floor, Gosu::Color::BLUE)
    end
end