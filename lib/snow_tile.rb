=begin
    the snow that is contained on a single tile
=end

class SnowTile
    def initialize(x, y, amount)
        @x, @y, @amount = x, y, amount
    end

    def to_destroy?
        return (@amount <= 0)
    end

    # to handle snow quantity, object will be destroyed if 0
    def update

    end

    def draw
    
    end
end