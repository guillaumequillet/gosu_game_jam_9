class Hero
    Z_ORDER = 1000

    attr_reader :x, :y
    def initialize(scene, x = 0, y = 0)
        @scene = scene
        @x, @y = x, y
        @floor = @y
        @min_speed = 0.0
        @max_speed = 0.15
        @speed = @max_speed

        @width = 128
        @height = 128
        @scale = 0.6

        @sprites = Gosu::Image.load_tiles('gfx/player.png', @width, @height, retro: true)

        @keys = {
            grip: [Gosu::KB_SPACE],
            right: [Gosu::KB_RIGHT, Gosu::KB_D],
            left: [Gosu::KB_LEFT, Gosu::KB_A],
            throw: [Gosu::KB_UP, Gosu::KB_S]
        }

        @gripping = false
        @throwing = false
        @throwing_speed = 0.5
    end

    def button_down(id)
        unless @throwing || @gripping
            if @keys[:throw].any?{|key| key == id}
                throw_ball
            end
        end
    end

    def update(dt, snowball)
        if @throwing
            # todo : animate the player
            @throwing = false
        else
            # movement
            speed = @speed * dt
            move(speed)  if @keys[:right].any?{|key| Gosu.button_down?(key)}
            move(-speed) if @keys[:left].any?{|key| Gosu.button_down?(key)}

            # snowball interaction
            if @keys[:grip].any?{|key| Gosu.button_down?(key)} && snowball.collides_hero?(@x)
                @gripping = true
                snowball.hero_push(speed)  if @keys[:right].any?{|key| Gosu.button_down?(key)}
                snowball.hero_push(-speed) if @keys[:left].any?{|key| Gosu.button_down?(key)}
            else
                @gripping = false
                snowball.slowdown  
            end
        end
    end

    def move(speed)
        @x += speed

        @x = 16 if @x < 16
    end

    def throw_ball
        @throwing = true
        @scene.add_projectile(Projectile.new(@scene.map, @x, @y, @x, -1000, @throwing_speed, :hero))
        @scene.play_sound(:throw, 0.4)
    end

    def draw
        frame = 0

        @sprites[frame].draw_rot(@x, @y, Z_ORDER, 0.0, 0.5, 1.0, @scale, @scale)
        # Gosu.draw_rect(@x - @width / 2, @y - @height, @width, @height, Gosu::Color::GREEN, Z_ORDER)
        # Gosu.draw_rect(@x - 2, @y - 2, 4, 4, Gosu::Color::RED, Z_ORDER)
    end
end