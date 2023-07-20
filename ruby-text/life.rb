#!/usr/bin/env ruby

# https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
# world grid is stored as a hash (key=[x,y], value=1 if on/live)
# optimized for 2d, coordinates kept as [x, y]

# NOTE TODO: incomplete as wrapping is not implemented but we don't find the actual min/max x&y for an infinite plane

class World
  attr_accessor :current, :next

  def initialize(on_cells: nil)
    self.current = Hash.new
    self.next = Hash.new
    on_cells.each do |coord|
      self.current[coord] = 1
    end
  end

  def save
    self.current = self.next
    self.next = self.current.dup
  end

  def is_currently_live(coord)
    self.current[coord] == 1
  end

  def cell_count(coord)
    is_currently_live(coord) ? 1 : 0
  end

  def record_next(coord, val)
    self.next[coord] = val
  end

  def neighbor_count(loc)
    # implement infinite (max_int) cartesian grid
    # future: implement optional wrapping
    x, y = loc
    x1 = cell_count([x-1, y-1])
    x2 = cell_count([x-1, y])
    x3 = cell_count([x-1, y+1])
    x4 = cell_count([x, y-1])
    #x5 = cell_count([x, y])
    x6 = cell_count([x, y+1])
    x7 = cell_count([x+1, y-1])
    x8 = cell_count([x+1, y])
    x9 = cell_count([x+1, y+1])
    x1 + x2 + x3 + x4 + x6 + x7 + x8 + x9
  end
end

class Game
  attr_accessor :world

  def initialize(world: nil)
    self.world = world || World.new
  end

  def evolve
    # Any live cell with two or three live neighbours survives.
    # Any dead cell with three live neighbours becomes a live cell.
    # All other live cells die in the next generation. Similarly, all other dead cells stay dead.
    x, y = active_size
    xmin, xmax = x
    ymin, ymax = y
    (ymin..ymax).each do |y|
      (xmin..xmax).each do |x|
        coord = [x, y]
        live = world.is_currently_live(coord)
        count = world.neighbor_count(coord)
        record = 0
        record = 1 if live && (count == 2 || count == 3)
        record = 1 if !live && count == 3
        world.record_next(coord, record)
      end
    end
    world.save
  end

  def dump
    clear_screen
    print_grid
  end

  def print_grid
    x, y = active_size
    xmin, xmax = x
    ymin, ymax = y
    (ymin..ymax).each do |y|
      (xmin..xmax).each do |x|
        print world.is_currently_live([x, y]) ? "x" : "."
      end
      puts
    end
  end

  def clear_screen
    puts "\e[H\e[2J"
  end

  def active_size
    [[-10, 10], [-10, 10]]
  end

  def run(count: 1, wait: 0.5)
    (1..count).each do
      evolve
      dump
      sleep(wait)
    end
  end
end

test = [[1,1], [2,2], [3,3]]
block = [[1,1], [1,2], [2,1], [2,2]]
blinker = [[1,1], [2,1], [3,1]]
glider = [[2,1], [3,2], [1,3], [2,3], [3,3]]
full = [[-4,-4], [-4,-3], [-3,-3], [-3,-4],
        [2,1], [3,2], [1,3], [2,3], [3,3],
        [4,8], [5,8], [6,8]]
grid = full

count = 20
wait = 0.5

world = World.new(on_cells: grid)
game = Game.new(world: world)
game.run(count: count, wait: wait)
