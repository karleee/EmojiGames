require_relative "tile"
require "colorize"

class Board
    attr_reader :grid
    BOMB, HIDDEN, FLAG = "💣", "⬜️", "🚩"
    VALUE_EMOJIS = {
        0 => "0️⃣ ", 
        1 => "1️⃣ ", 
        2 => "2️⃣ ", 
        3 => "3️⃣ ", 
        4 => "4️⃣ ",
        5 => "5️⃣ ",
        6 => "6️⃣ ",
        7 => "7️⃣ ",
        8 => "8️⃣ ",
        "💣" => "💣"
    }

    # initializes a new board with a grid of spaces
    def initialize
        self.make_board
    end

    # allows for easy access to positions on the board
    def [](pos)
        row, col = pos
        @grid[row][col]
    end

    # makes a new board (initializes) with the bombs placed
    def make_board
        @grid = Array.new(9) { | row | Array.new(9) { | col | Tile.new(self, [row, col]) } }
        self.place_bombs
        @grid.map.with_index do | row, rowIndx |
            row.map.with_index { | tile, colIndx | tile.neighbors_bomb_count if !(self.is_a_bomb?([rowIndx, colIndx])) }
        end
    end

    # randomly places bombs onto the grid
    def place_bombs
         range = (0...@grid.length).to_a
         total_bombs = (@grid.length ** 2) / 4
         @grid[range.sample][range.sample].value = BOMB until @grid.flatten.map(&:value).count(BOMB) == total_bombs
    end

    # checks a position on the grid to see if the tile is a bomb
    def is_a_bomb?(pos)
        tile = @grid[pos[0]][pos[1]]
        tile.value == BOMB
    end

    # reveals all bomb locations if the player loses
    def reveal_bombs
        all_bombs = @grid.flatten.select { | tile | tile.value == BOMB }
        all_bombs.each { | tile | tile.reveal }
    end

    # checks if the entire board of non-bomb tiles are flipped over
    def won?
        safe_tiles = @grid.flatten.select { | tile | tile.value != BOMB }
        safe_tiles.all? { | tile | tile.revealed }
    end

    # checks if all bomb tiles are flipped over
    def lost?
        all_bombs = @grid.flatten.select { | tile | tile.value == BOMB }
        all_bombs.all? { | tile | tile.revealed }
    end

    # prints out board to the user
    def render
        print "   #{(1..9).to_a.join("    ")}".light_green.bold
        puts
        puts
        @grid.each.with_index do | row, row_indx |
            print "#{row_indx + 1}  ".light_green.bold
            row.each do | tile |
                if tile.revealed
                    print "#{VALUE_EMOJIS[tile.value]}   "
                elsif tile.flagged
                    print "#{FLAG}   "
                else  
                    print "#{HIDDEN}   "
                end
            end
            puts
            puts
        end
    end
end

board = Board.new
p board.grid.flatten.map(&:value)