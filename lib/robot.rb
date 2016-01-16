class Robot
  attr_reader :position, :items, :health
  attr_accessor :equipped_weapon

class RobotAlreadyDeadError < Exception
end

class UnattackableEnemy < Exception
end

  MAX_WEIGHT = 250
  MAX_HEALTH = 100
  DEFAULT_WEAK_ATTACK = 5

  def initialize
    @position = [0, 0]
    @items = []
    @health = MAX_HEALTH
    @equipped_weapon = nil
  end

  def move_left
    @position[0] -= 1
  end

  def move_right
    @position[0] += 1
  end

  def move_up
    @position[1] += 1
  end

  def move_down
    @position[1] -= 1
  end

  def pick_up(item)
    self.equipped_weapon = item if item.is_a?(Weapon)
    item.feed(self) if item.class == BoxOfBolts && health <= 80
      @items << item if can_pick_up?(item)

  end

  def items_weight
    @items.reduce(0) {|sum, item| sum += item.weight}
  end

  def can_pick_up?(item)
    items_weight + item.weight <= MAX_WEIGHT
  end

  def wound(hit)
    if @health >=0
      @health -= hit
      @health = 0 if @health <= 0
    else
      @health = 0
    end
  end

  def heal(pill)
    @health += pill
    @health = MAX_HEALTH if @health >= MAX_HEALTH
  end

  def low_health
    @health <= 80
  end

  def attack(enemy)
    raise RobotAlreadyDeadError, "Robot is already dead" if enemy.health <= 0
    raise UnattackableEnemy, "Can only attack robots" unless enemy.is_a?(Robot)
    if equipped_weapon.is_a?(Grenade) && grenade_range?(enemy)
        equipped_weapon.hit(enemy)
        @equipped_weapon = nil  
    end
    if within_range?(enemy)
      if equipped_weapon
        equipped_weapon.hit(enemy)
      else
        enemy.wound(DEFAULT_WEAK_ATTACK)
      end
    end
  end

  def grenade_range?(enemy)
   enemy.position.first.between?(-2, 2) && enemy.position.last.between?(-2, 2)   
  end

  def within_range?(enemy)
    enemy.position.first.between?(-1, 1) && enemy.position.last.between?(-1, 1)
  end

end
