class MazesController < ApplicationController

  def initialize
    @height = 10
    @width = 10  
    @maze = Array.new(@height) { Array.new(@width, 1) }
  end

  def generate
    start_row, start_col = rand(@height), rand(@width)
    @maze[start_row][start_col] = 0

    visited = Set.new
    recursive_backtracker(start_row, start_col, visited, @maze)

    render json: {maze: @maze}
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
        break 
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

  def recursive_backtracker(row, col, visited, maze)
    return unless valid_movement?(row, col, visited)
    
    visited << [row, col]
    maze[row][col] = 0

    directions = [[-1, 0], [0, 1], [1, 0], [0, -1]].shuffle

    directions.each do |dr, dc|
        new_row, new_col = row + dr, col + dc
        next_row, next_col = row + 2*dr, col + 2*dc

        if valid_movement?(next_row, next_col, visited)

            maze[new_row][new_col] = 0
            
            recursive_backtracker(next_row, next_col, visited, maze)
        end
    end
  end

  def valid_movement?(row, col, visited)
    row.between?(0, @maze.length - 1) &&
      col.between?(0, @maze[0].length - 1) &&
      !visited.include?([row, col])
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
