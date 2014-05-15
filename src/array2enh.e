indexing
	description: "An enhanced version of ARRAY2 made to work with SUDOKU, allows the splitting of the array into pieces that require analysis"
	author: "F. Lauffenburger, D. Tran"
	date: "26.12.05"
	revision: "$Revision$"

class
	ARRAY2ENH
inherit
	ARRAY2[INTEGER]
create
	make
feature -- 3x3 Splitter
	split (split_var:INTEGER):SPLITTET is
		-- splits the sudoku array into 3x3 quadrants. Split_var gives the quadrant wanted. 	1 - 2 - 3
		--																						4 - 5 - 6
		--																						7 - 8 - 9

		require 
		correct_values: (split_var >= 1) and (split_var <= 9)
		local x, y ,xcounter, ycounter: INTEGER 
		do
			create Result.make (3,3)
			if (split_var >= 1) and (split_var <= 3) then
				y:=1
				x:=(split_var - 1)*3 + 1
			elseif (split_var >= 4) and (split_var <=6) then
				y:=4
				x:=(split_var - 4)*3 + 1
			else
				y:=7
				x:=(split_var - 7)*3+1
			end
			from
				ycounter:=y
			until
				ycounter = y+3
			loop
				from
					xcounter:=x
				until
					xcounter = x+3
				loop
					Result.put (item (x, y), xcounter-x+1, ycounter-y+1)
					xcounter:=xcounter+1
				end
				ycounter:=ycounter+1
			end
		end	
	ack_undo_split (split_var:INTEGER; splitter:SPLITTET) is	
			-- takes a splitter and puts it back in its correct position (I hope)
		local x, y ,xcounter, ycounter: INTEGER 
		do
			if (split_var >= 1) and (split_var <= 3) then
				y:=1
				x:=(split_var - 1)*3 + 1
			elseif (split_var >= 4) and (split_var <=6) then
				y:=4
				x:=(split_var - 4)*3 + 1
			else
				y:=7
				x:=(split_var - 7)*3+1
			end
			from
				ycounter:=y
			until
				ycounter = (y+3)
			loop
				from
					xcounter:=x
				until
					xcounter = (x+3)
				loop
					put (splitter.item (xcounter-x+1, ycounter-y+1),xcounter ,ycounter )
					xcounter:=xcounter+1
				end
				ycounter:=ycounter+1
			end
			
		end
feature --Row/Column handling
	gimmerow(i:INTEGER):ARRAY[INTEGER] is		
			-- returns row I as an array
		local tick_tock:INTEGER
		do
			create Result.make (1,9)
			from
				tick_tock:=1
			until
				tick_tock>9
			loop
				Result.put(item(tick_tock, i), tick_tock)
				tick_tock:=tick_tock+1
			end
		end
	gimmecolumn(i:INTEGER):ARRAY[INTEGER] is
			-- returns column I as an array
		local tick_tock:INTEGER
		do
			create Result.make (1,9)
			from
				tick_tock:=1
			until
				tick_tock>9
			loop
				Result.put(item(i, tick_tock), tick_tock)
				tick_tock:=tick_tock+1
			end
		end

feature --visualization
	print_it is
			-- Prints sudok_matrix, will be obsolete after David Trans Implementation
	local
		x, y: INTEGER
	do	
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
				io.putstring(item (x, y).out)
				y:=y+1
			end
		io.new_line
		x:=x+1
		end
	end
invariant
	please_9x9_only: (height <=9 and width <=9)
end
