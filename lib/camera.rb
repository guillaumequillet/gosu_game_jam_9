class Camera
    def initialize(window, target)
        @window = window
        @target = target
        @x, @y = @target.x, @target.y
        @height = 64
    end

    def update(dt)
        target_x = @target.x - @window.width / 2
        target_y = @target.y - @window.height + @height
        @x = lerp(@x, target_x, 0.1)
        @y = lerp(@y, target_y, 0.1)
    end

    def lerp(a, b, t)
        a + (b - a) * t
    end

    def look
        Gosu.translate(-@x, -@y) do
            yield
        end
    end
end