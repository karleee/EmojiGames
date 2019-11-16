require_relative "board"
require "colorize"

class Game
    # initializes a new game instance with a new board
    def initialize(board)
        @board = board
    end

    # prompts the player for a position
    def get_full_move
        puts "Action Types: E to explore a tile and F to toggle a flag".white.bold
        puts "Enter a row, column, and action type separated by spaces:".white.bold
        input = gets.chomp.split
        pos, action = input[0..1].map { | num | num.to_i - 1 }, input[-1]
        until valid_pos?(pos) && valid_action?(action)
            system("clear")
            @board.render
            puts "Full moves need a row, column and action type".light_red.bold
            puts "Action Types: E to explore a tile and F to toggle a flag".white.bold
            puts "Enter a row, column, and action type separated by spaces:".white.bold
            input = gets.chomp.split
            pos, action = input[0..1].map { | num | num.to_i - 1 }, input[-1]
        end
        input
    end

    # gets the position from the full move
    def get_position(full_move)
        full_move[0..1].map { | num | num.to_i - 1 }
    end

    # checks for valid user position input
    def valid_pos?(pos)
        range = (0...@board.grid.length).to_a
        pos.length == 2 && range.include?(pos[0]) && range.include?(pos[1])
    end

    # gets the action from the full move
    def get_action(full_move)
        full_move.last
    end

    # checks for valid action type
    def valid_action?(input)
        input.length == 1 && (input.downcase == "e" || input.downcase == "f")
    end

    # checks for a valid tile flip
    def valid_flip?(pos)
        !(@board[pos].flagged)
    end

    # displays unflaggint message
    def display_unflag_message
        system("clear")
        @board.render
        puts "To explore one must unflag first".light_red.bold
    end
    
    # displays losing output
    def display_loss
        system("clear")
        @board.render
        puts
        puts "GAME OVER, better luck next time!".light_red.bold
    end

    # displays winning output
    def display_win
        system("clear")
        @board.render
        puts
        puts "Congratulations, you avoided the bombs!".yellow.bold
    end

    # displays main game screen with instructions
    def display_instructions
        system("clear")
        40.times { print "-".white.bold}
        puts
        puts "Welcome to MINESWEEPER 💣".white
        40.times { print "-".white.bold}
        puts
        puts
        puts "Mines ".light_red + "are aplenty and ".white + "lives ".light_red + "are scarce.\nDiscover a bomb and c'est la vie!\n\nTo aid you in your perilous journey, rows\nand columns are ".white + "numbered ".light_red + "on the side."
        puts
        puts "Enter any key to continue".white.bold
        puts "Enter Q to quit".white.bold
        gets.chomp
    end
    
    # game loop to play one round
    def play_round
        system("clear")
        @board.render
        puts
        full_move = self.get_full_move
        pos = self.get_position(full_move)
        action = self.get_action(full_move)
        while action.downcase == "e" && !(self.valid_flip?(pos))
            self.display_unflag_message
            full_move = self.get_full_move
            pos = self.get_position(full_move)
            action = self.get_action(full_move)
        end
        action.downcase == "e" ? @board[pos].reveal : @board[pos].toggle_flag
        @board.reveal_bombs if @board.is_a_bomb?(pos) && @board[pos].revealed
    end

    # game loop to run an entire game
    def run
        start_key = self.display_instructions
        exit if start_key.downcase == "q"
        self.play_round until @board.won? || @board.lost?
        @board.lost? ? self.display_loss : self.display_win
    end
end

board = Board.new
game = Game.new(board)
game.run