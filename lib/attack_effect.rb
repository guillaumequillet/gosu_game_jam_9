class AttackEffect
    LIMIT = 50

    def initialize(x, y)
        @particles = []
        LIMIT.times { generate_particle(x, y) }
    end

    def update(dt)
        @particles.each {|particle| particle.update(dt)}
        @particles.delete_if {|particle| particle.to_delete?}
    end

    def to_delete?
        return @particles.empty?
    end

    def generate_particle(x, y)
        angle = Gosu.random(0, 360)
        size = Gosu.random(1, 5)
        @particles.push AttackParticle.new(x, y, angle, size)
    end

    def draw
        @particles.each {|particle| particle.draw}
    end
end

class AttackParticle
    Z_ORDER = 50
    
    def initialize(x, y, angle, size)
        @x, @y = x, y 
        @angle = angle
        @size = size
        @speed = Gosu.random(0.01, 0.2)
        @alpha_speed = Gosu.random(0.6, 1.0)
        @alpha = 255
        @color = Gosu::Color.new(@alpha, 255, 255, 255)
    end

    def to_delete?
        return @alpha <= 0
    end

    def update(dt)
        speed = @speed * dt
        @x += Gosu.offset_x(@angle, speed)
        @y += Gosu.offset_y(@angle, speed)
        @alpha -= (dt * @alpha_speed).floor
        @alpha = 0 if @alpha < 0
        @color = Gosu::Color.new(@alpha, 255, 255, 255)
    end

    def draw
        Gosu.draw_rect(@x - @size / 2, @y - @size / 2, @size, @size, @color, Z_ORDER)
    end
end