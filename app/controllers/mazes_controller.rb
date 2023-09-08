class MazesController < ApplicationController

  def generate
    width = 10
    height = 10

    @maze = Array.new(height) { Array.new(width, 1)}

    recursive_backtracker(rand(height), rand(width))

    render json: { maze: @maze}
  end

  def solve
    # Get maze from params
    # Implement maze solving logic here

    render json: { solution: @solution}
  end

  private
  def recursive_backtracker(row, col, visited=[])
    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]].shuffle

    visited << [row, col]
    @maze[row][col] = 0

    directions.each do |dr, dc|
      new_row, new_col = row + dr, col + dc

      if new_row.between?(0, @maze.length - 1) && new_col.between?(0, @maze[0].length - 1) && !visited.include?([new_row, new_col])

        @maze[row + dr / 2][col + dc / 2] = 0
  

        recursive_backtracker(new_row, new_col, visited)
      end
    end
  end
end
