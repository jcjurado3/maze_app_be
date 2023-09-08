class MazesController < ApplicationController

  def generate
    width = 10
    height = 10

    @maze = Array.new(height) { Array.new(width, 1)}

    recursive_backtracker(rand(height), rand(width))

    render json: { maze: @maze}
  end

  def solve
    start = [0, 0]
    exit = [@maze.length - 1, @maze[0].length - 1]

    visited = []
    stack = [start]
    path = []

    while !stack.empty?
      current = stack.pop
  
      if current == exit
        break # Exit the loop if the end is reached
      end
  
      visited << current
      path << current
  
      neighbors = get_neighbors(current[0], current[1])
      
      neighbors.each do |neighbor|
        if @maze[neighbor[0]][neighbor[1]] == 0 && !visited.include?(neighbor)
          stack.push(neighbor)
        end
      end
  
      if stack.last != path.last
        path.pop
      end
    end

    if path.last == exit
      render json: { solution: path }
    else
      render json: { error: "No solution found" }
    end
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
    
    def get_neighbors(row, col)
      directions = [[-1, 0], [0, 1], [1, 0], [0, -1]]
      neighbors = []
    
      directions.each do |dr, dc|
        new_row, new_col = row + dr, col + dc
        if new_row.between?(0, @maze.length - 1) && new_col.between?(0, @maze[0].length - 1)
          neighbors << [new_row, new_col]
        end
      end
    
      return neighbors
    end
  end
end
