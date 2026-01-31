class Hero
    Z_ORDER = 5

    attr_reader :x, :y
    def initialize(scene, x = 0, y = 0)
        @scene = scene
        @x, @y = x, y
        @min_speed = 0.0
        @max_speed = 0.15
        @speed = @max_speed

        @width = 32
        @height = 32

        @keys = {
            grip: [Gosu::KB_DOWN, Gosu::KB_S],
            right: [Gosu::KB_RIGHT, Gosu::KB_D],
            left: [Gosu::KB_LEFT, Gosu::KB_A],
            throw: [Gosu::KB_UP, Gosu::KB_W]
        }

        @throwing = false
        @throwing_speed = 0.5
    end

    def button_down(id)
        unless @throwing
            throw_ball if @keys[:throw].any?{|key| key == id}
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
                snowball.hero_push(speed)  if @keys[:right].any?{|key| Gosu.button_down?(key)}
                snowball.hero_push(-speed) if @keys[:left].any?{|key| Gosu.button_down?(key)}
            else
                snowball.slowdown  
            end
        end
    end

    def move(speed)
        @x += speed
    end

    def throw_ball
        @throwing = true
        @scene.add_projectile(Projectile.new(@scene.map, @x, @y, @x, -1000, @throwing_speed))
        @scene.play_sound(:throw, 0.4)
    end

    def draw
        Gosu.draw_rect(@x - @width / 2, @y - @height, @width, @height, Gosu::Color::GREEN, Z_ORDER)
        Gosu.draw_rect(@x - 2, @y - 2, 4, 4, Gosu::Color::RED, Z_ORDER)
    end
end