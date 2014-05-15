indexing
	description: "Have to do with the SUDOKU puzzle"
	author: "F. Lauffenburger and D. Tran"
	date: "25.12.05"
	revision: "$Revision$"

class
	SUDOKU
create
	make, maketemp

feature -- Access
	sudoku_matrix :ARRAY2ENH	-- Matrix containing the current SUDOKU in its unsolved/solved state
								-- solved:ARRAY2ENH

feature -- Initialization
	make is
			-- basic make feature that initializes a 2D matrix 9x9 with all 0's
		local x, y: INTEGER
		do
			create sudoku_matrix.make (9,9)
			from
				x:=1
			until
				x>9
			loop
				from
					y:=1
				until
					y>9
				loop
					sudoku_matrix.put(0,x,y)
					y:=y+1
				end
				x:=x+1
			end
		end
		
	
	maketemp is
			-- Stupid make thing I use to test my brain
	do
		create sudoku_matrix.make (9, 9)
		sudoku_matrix.put (0, 1, 1)
		sudoku_matrix.put (0, 1, 2)
		sudoku_matrix.put (6, 1, 3)
		sudoku_matrix.put (0, 1, 4)
		sudoku_matrix.put (0, 1, 5)
		sudoku_matrix.put (0, 1, 6)
		sudoku_matrix.put (0, 1, 7)
		sudoku_matrix.put (0, 1, 8)
		sudoku_matrix.put (7, 1, 9)
		sudoku_matrix.put (0, 2, 1)	
		sudoku_matrix.put (0, 2, 2)		
		sudoku_matrix.put (8, 2, 3)		
		sudoku_matrix.put (0, 2, 4)		
		sudoku_matrix.put (9, 2, 5)		
		sudoku_matrix.put (5, 2, 6)		
		sudoku_matrix.put (0, 2, 7)		
		sudoku_matrix.put (0, 2, 8)		
		sudoku_matrix.put (0, 2, 9)
		sudoku_matrix.put (0, 3, 1)		
		sudoku_matrix.put (4, 3, 2)		
		sudoku_matrix.put (0, 3, 3)		
		sudoku_matrix.put (6, 3, 4)		
		sudoku_matrix.put (7, 3, 5)		
		sudoku_matrix.put (3, 3, 6)		
		sudoku_matrix.put (8, 3, 7)		
		sudoku_matrix.put (0, 3, 8)		
		sudoku_matrix.put (0, 3, 9)
		sudoku_matrix.put (0, 4, 1)		
		sudoku_matrix.put (0, 4, 2)		
		sudoku_matrix.put (0, 4, 3)		
		sudoku_matrix.put (0, 4, 4)		
		sudoku_matrix.put (4, 4, 5)		
		sudoku_matrix.put (0, 4, 6)		
		sudoku_matrix.put (9, 4, 7)		
		sudoku_matrix.put (0, 4, 8)		
		sudoku_matrix.put (0, 4, 9)		
		sudoku_matrix.put (1, 5, 1)		
		sudoku_matrix.put (8, 5, 2)		
		sudoku_matrix.put (0, 5, 3)		
		sudoku_matrix.put (0, 5, 4)		
		sudoku_matrix.put (0, 5, 5)		
		sudoku_matrix.put (0, 5, 6)		
		sudoku_matrix.put (0, 5, 7)		
		sudoku_matrix.put (0, 5, 8)		
		sudoku_matrix.put (3, 5, 9)
		sudoku_matrix.put (0, 6, 1)		
		sudoku_matrix.put (0, 6, 2)		
		sudoku_matrix.put (7, 6, 3)		
		sudoku_matrix.put (1, 6, 4)		
		sudoku_matrix.put (5, 6, 5)		
		sudoku_matrix.put (0, 6, 6)		
		sudoku_matrix.put (0, 6, 7)		
		sudoku_matrix.put (6, 6, 8)		
		sudoku_matrix.put (0, 6, 9)			
		sudoku_matrix.put (0, 7, 1)		
		sudoku_matrix.put (0, 7, 2)		
		sudoku_matrix.put (9, 7, 3)		
		sudoku_matrix.put (5, 7, 4)		
		sudoku_matrix.put (0, 7, 5)		
		sudoku_matrix.put (0, 7, 6)		
		sudoku_matrix.put (2, 7, 7)		
		sudoku_matrix.put (0, 7, 8)		
		sudoku_matrix.put (0, 7, 9)		
		sudoku_matrix.put (4, 8, 1)		
		sudoku_matrix.put (0, 8, 2)		
		sudoku_matrix.put (0, 8, 3)		
		sudoku_matrix.put (0, 8, 4)		
		sudoku_matrix.put (0, 8, 5)		
		sudoku_matrix.put (2, 8, 6)		
		sudoku_matrix.put (7, 8, 7)		
		sudoku_matrix.put (9, 8, 8)		
		sudoku_matrix.put (0, 8, 9)		
		sudoku_matrix.put (2, 9, 1)		
		sudoku_matrix.put (1, 9, 2)		
		sudoku_matrix.put (0, 9, 3)		
		sudoku_matrix.put (0, 9, 4)		
		sudoku_matrix.put (3, 9, 5)		
		sudoku_matrix.put (0, 9, 6)		
		sudoku_matrix.put (0, 9, 7)		
		sudoku_matrix.put (0, 9, 8)		
		sudoku_matrix.put (0, 9, 9)
	-- boy was that boring	
	-- solve(sudoku_matrix)			
	end
end
