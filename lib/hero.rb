class Hero
    def initialize(x = 0, y = 0)
        @x, @y = x, y
        @speed = 0.6

        @width = 32
        @height = 64

        @keys = {
            right: [Gosu::KB_RIGHT, Gosu::KB_D],
            left: [Gosu::KB_LEFT, Gosu::KB_A]
        }
    end

    def button_down(id)
    
    end

    def update(dt)
        speed = @speed * dt
        move(speed)  if @keys[:right].any?{|key| Gosu.button_down?(key)}
        move(-speed) if @keys[:left].any?{|key| Gosu.button_down?(key)}
    end

    def move(speed)
        @x += speed
    end

    def draw
        Gosu.draw_rect(@x - @width / 2, @y - @height, @width, @height, Gosu::Color::GREEN)
    end
end