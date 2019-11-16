class Tile
    BOMB = "💣"
    attr_reader :pos, :flagged
    attr_accessor :value, :revealed

    def initialize(board, pos)
        @board, @pos, @value = board, pos, 0
        @revealed, @flagged = false, false
    end

    def toggle_flag
        @flagged = !(@flagged)
    end

    # finds all adjacent neighbors of a tile
    def neighbors
        range = (0...@board.grid.length).to_a
        position_changes = [[0, -1], [0, 1], [1, -1], [1, 0], [1, 1], [-1, -1], [-1, 0], [-1, 1]]
        changed = position_changes.map { | change | [@pos[0] + change[0], @pos[1] + change[1]] }
        changed.select { | pos | range.include?(pos[0]) && range.include?(pos[1]) && !(@board[pos].revealed) && !(@board[pos].flagged) }
    end

    # returns the bomb count in neighboring cells
    def neighbors_bomb_count        
        neighbors = self.neighbors
        @value = neighbors.select { | pos | @board[pos].value == BOMB }.length
    end

    # reveals all neighbors that contain no bombs
    def reveal
        @revealed = true
        neighbors = self.neighbors
        if neighbors.none? { | pos | @board[pos].value == BOMB } && !(@board.is_a_bomb?(@pos))
            neighbors.each do | pos | 
                @board[pos].revealed = true
                @board[pos].reveal
            end
        end
    end
end