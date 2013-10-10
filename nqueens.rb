

class Queen 
  attr_accessor :x, :y
  def initialize(x = 0, y = 0)
    @x, @y = x, y
  end
  def == (other)
    @y == other.y || @x == other.x || (@x-other.x).abs == (@y - other.y).abs
  end
end


class Board
  attr_accessor :board
  def initialize n
    @n = n
    @board = Array.new
    @row = 1
    @col = 1
    @back = 0
  end

  def play
    @board << Queen.new(@row, @col)
    @col = 2
    while @board.size < @n
      if add_if_can(@col, @back)
        @back = 0
        @col += 1
      else
        @col -= 1 
        begin
          @back = @board.at(@col-1).x
          @board.delete_at(@col-1)
        rescue
          puts "Brak rozwiazania"
          break
        end
      end
    end  
    draw 
  end

  def add_if_can(c, back)
    back > 0 ? row = back+1 : row = 1
    row.upto(@n) do |r|
      if can_add?(r, c)
        @board << Queen.new(r, c)
        @back = 0
        return true
      end
    end
    @back = 0
    return false
  end

  def can_add? (row, col)
    @board.map { |q| return false if q == Queen.new(row, col) }
    return true
  end

  def draw 
    @n.times do |i|
      @n.times do |j|
        if @board[i].x == j+1
          print " x "
        else
          print " - "
        end
      end
      puts
    end
  end
end

c = Board.new(4)
c.play
c.board.each {|c| puts "Wiersz: #{c.x}, kolumna: #{c.y}"}