

class Queen
  attr_accessor :x, :y
  def initialize(x, y)
    @x, @y = x, y
  end
  def == (other)
    @y == other.y || @x == other.x || (@x-other.x).abs == (@y - other.y).abs
  end
  def swap other
    tmp = @x
    @x = other.x
    other.x = tmp
  end
end

class Person
  attr_accessor :board
  def initialize n
    @n = n
    @board = Array.new
    init_board @n
  end
  def init_board n
    (n).times{ |i| @board << Queen.new(1+rand(n), i + 1)}
  end

  def score
    @board.map do |p|
      @board.find_all { |q| q == p }.count - 1 
    end.reduce(:+)
  end

  def renew
    @board = Array.new
    init_board @n
  end

  def recombination
    if rand > 0.7
      s = (@board.size/2).floor
      a = @board.sample(s)
      b = @board.sample(s)
      s.times do |i|
        x = b[i].x
        b[i].x = a[i].x
        a[i].x = x
      end
    end
  end

  def mutation
    if rand.between?(0.01, 0.2)
      s = @board.size - 1
      @board.at(1 + rand(s)).x = 1 + rand(s)
    end
  end

  def crossing
    recombination
    mutation
  end
end

class Population
  attr_accessor :pub
  def initialize numbers, n
    @numbers = numbers
    @pub = Array.new
    init numbers, n
    @gen = 0
  end
  def init numbers, n
    numbers.times {@pub << Person.new(n)}
  end

  def selection
    @gen += 1
    s = (@numbers/2).floor
    @pub = @pub.sort { |a, b| a.score <=> b.score }.reverse
    if @pub.find {|q| q.score == 0}
      puts @gen
      return true 
    end
    @pub[0..s].map! { |p| p.renew }
    @pub.map { |p| p.crossing }
    false
  end
end

class Evolution
  def initialize n
    @n = n
    @population = Population.new(100, @n)
  end

  def start
    while !@population.selection do
    end
    a = @population.pub.find_all {|d| d.score == 0}
    a.each { |b| puts; draw b.board }
    a
  end

  def draw pop
    @n.times do |i|
      @n.times do |j|
        if pop[i].x == j+1
          print " x "
        else
          print " - "
        end
      end
      puts
    end
  end
end



a = Evolution.new(6)

a.start


