class Snow
    LIMIT = 300
    def initialize(window, hero)
        @window = window
        @hero = hero
        @particles = []

        # first generation, middle screen to fill it at launch
        LIMIT.times { generate_particle(Gosu.random(0, window.height)) }
    end

    def update(dt)
        if @particles.size < LIMIT
            (LIMIT - @particles.size).times { generate_particle }
        end

        @particles.each {|particle| particle.update(dt)}

        @particles.delete_if {|particle| particle.to_delete?}
    end

    def generate_particle(y = -100)
        x = Gosu.random(@hero.x - @window.width / 2 - 150, @hero.x + @window.width / 2 + 150)
        @particles.push SnowParticle.new(@window, x, y)
    end

    def draw
        @particles.each {|particle| particle.draw}
    end
end

class SnowParticle
    def initialize(window, x, y)
        @window = window
        @x, @y = x, y 
        @angle = Gosu.random(140, 220)
        @size = Gosu.random(2, 5)
        @speed = Gosu.random(0.1, 0.2)
    end

    def to_delete?
        return @y >= @window.height
    end

    def update(dt)
        speed = @speed * dt
        @x += Gosu.offset_x(@angle, speed)
        @y += Gosu.offset_y(@angle, speed)
    end

    def draw
        color = Gosu::Color.new(128, 255, 255, 255)
        Gosu.draw_rect(@x - @size / 2, @y - @size / 2, @size, @size, color, 20)
    end
end