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
        @orientation = 1

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
        @throwing_tick = nil
        @frame_duration = 300
        @frame = 0
        @subframe = 0
        @subframe_tick = nil

        @max_bump = 5
        @bump = 0
        @bump_way = :up
    end

    def button_down(id)
        if @throwing == false
            if @keys[:throw].any?{|key| key == id}
                throw_ball
            end
        end
    end

    def update(dt, snowball)
        @throwing_tick = Gosu.milliseconds if @throwing_tick.nil?
        @subframe_tick = Gosu.milliseconds if @subframe_tick.nil?

        if @throwing
            @frame = 1 if @throwing && Gosu.milliseconds - @throwing_tick <= @frame_duration / 2        
            @frame = 2 if @throwing && Gosu.milliseconds - @throwing_tick >= @frame_duration / 2  

            if Gosu.milliseconds - @throwing_tick >= @frame_duration
                @throwing = false
            end
        # not throwing
        else
            # movement
            speed = @speed * dt 

            if @keys[:right].any?{|key| Gosu.button_down?(key)}
                move(speed)
                @moving = true  
            elsif @keys[:left].any?{|key| Gosu.button_down?(key)}
                move(-speed)
                @moving = true
            else
                @moving = false
            end

            if !@moving
                @frame = 0
                @bump = 0
                snowball.slowdown  
            # we're moving
            else
                bump_speed = (dt * 0.02)
                @bump += (@bump_way == :up) ? bump_speed : -bump_speed
                
                if @bump_way == :up && @bump >= @max_bump
                    @bump = @max_bump
                    @bump_way = :down
                end

                if @bump_way == :down && @bump <= 0
                    @bump = 0
                    @bump_way = :up
                end

                # snowball interaction
                if @keys[:grip].any?{|key| Gosu.button_down?(key)} && snowball.collides_hero?(@x)
                    @gripping = true
                    snowball.hero_push(speed)  if @keys[:right].any?{|key| Gosu.button_down?(key)}
                    snowball.hero_push(-speed) if @keys[:left].any?{|key| Gosu.button_down?(key)}
                else
                    @gripping = false
                    snowball.slowdown  
                end

                if Gosu.milliseconds - @subframe_tick >= @frame_duration
                    @subframe_tick = Gosu.milliseconds
                    @subframe = (@subframe == 0) ? 1 : 0
                end

                # offset according to action
                @frame = @gripping ? (3 + @subframe) : (5 + @subframe)
            end
        end
    end

    def move(speed)
        @x += speed
        @x = 32 if @x < 32
        @orientation = (speed > 0) ? 1 : -1
    end

    def throw_ball
        unless @scene.snowball.collides_hero?(@x) # can't throw if in front of the ball
            @orientation = 1
            @throwing = true
            @throwing_tick = Gosu.milliseconds
            @scene.add_projectile(Projectile.new(@scene.map, @x, @y, @x, -1000, @throwing_speed, :hero))
            @scene.play_sound(:throw, 0.4)
        end
    end

    def draw
        @sprites[@frame].draw_rot(@x, @y - @bump, Z_ORDER, 0.0, 0.5, 1.0, @scale * @orientation, @scale)
    end
end