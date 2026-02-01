class Scene
    def initialize(window)
        @window = window
        @font = Gosu::Font.new(24)
    end

    def button_down(id)

    end

    def update(dt)

    end

    def draw

    end
end

class SceneVictory < Scene
    def initialize(window)
        super(window)
        @gfx = Gosu::Image.new('gfx/finished.png', retro: true)
    end

    def draw
        @gfx.draw(0, 0, 0)
        @font.draw_text("Snowball Score : #{$snowball_score}", 200, 180, 0, 1, 1, Gosu::Color::BLACK)
        @font.draw_text("Ennemy Score : #{$ennemy_score}", 200, 210, 0, 1, 1, Gosu::Color::BLACK)
        @font.draw_text("TOTAL SCORE : #{$ennemy_score + $snowball_score}", 90, 260, 0, 2, 2, Gosu::Color::BLACK)
    end

    def button_down(id)
        @window.switch_scene(:game)
    end
end

class SceneGame < Scene
    attr_reader :window, :camera, :map, :snowball, :hero

    def initialize(window)
        super(window)
        @sfx = {
            hit: Gosu::Sample.new('sfx/hit.mp3'),
            throw: Gosu::Sample.new('sfx/throw.mp3')
        }
        reset
    end
    
    def reset
        @floor = @window.height / 1.5
        @map = Map.new(self, @floor)
        @hero = Hero.new(self, 32, @floor)
        @camera = Camera.new(@window, @hero)
        @snowball = Snowball.new(self, 100, @floor)
        @snow = Snow.new(window, @hero)
        @projectiles = []
        @attack_effects = []        
        $snowball_score = 0
        $ennemy_score = 0
    end

    def button_down(id)
        @hero.button_down(id)
    end

    def play_sound(sound, volume = 1, speed = 1, looping = false)
        @sfx[sound].play(volume, speed, looping)
    end

    def add_projectile(projectile)
        @projectiles.push projectile
    end
    
    def attack_effect(target_x, target_y)
        @attack_effects.push AttackEffect.new(target_x, target_y)
    end

    def game_over
        reset
    end

    def update(dt)
        @hero.update(dt, @snowball)
        @camera.update(dt)
        @snowball.update(dt)
        @map.update(@hero, @snowball, dt)
        @snow.update(dt)

        @projectiles.each {|projectile| projectile.update(dt)}
        @projectiles.delete_if {|projectile| projectile.outside?(@camera)}

        @attack_effects.each {|attack_effect| attack_effect.update(dt)}
        @attack_effects.delete_if {|attack_effect| attack_effect.to_delete?}
    end

    def draw
        @camera.look do
            @hero.draw
            @snowball.draw
            @map.draw
            @projectiles.each {|projectile| projectile.draw}
            @attack_effects.each {|attack_effect| attack_effect.draw}
            @snow.draw
        end
    end
end