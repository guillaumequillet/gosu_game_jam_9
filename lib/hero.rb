class Hero
    attr_reader :x, :y
    def initialize(x = 0, y = 0)
        @x, @y = x, y
        @min_speed = 0.0
        @max_speed = 0.2
        @speed = @max_speed

        @width = 32
        @height = 32

        @keys = {
            right: [Gosu::KB_RIGHT, Gosu::KB_D],
            left: [Gosu::KB_LEFT, Gosu::KB_A]
        }
    end

    def button_down(id)
    
    end

    def update(dt, snowball)
        # movement
        speed = @speed * dt
        move(speed)  if @keys[:right].any?{|key| Gosu.button_down?(key)}
        move(-speed) if @keys[:left].any?{|key| Gosu.button_down?(key)}

        # snowball interaction
        if snowball.collides_hero?(@x + snowball.size * 0.3)
            snowball.hero_push(speed)
        else
            snowball.slowdown   
        end
    end

    def move(speed)
        @x += speed
    end

    def draw
        Gosu.draw_rect(@x - @width / 2, @y - @height, @width, @height, Gosu::Color::GREEN, 1)
        Gosu.draw_rect(@x - 2, @y - 2, 4, 4, Gosu::Color::RED, 1)
    end
end