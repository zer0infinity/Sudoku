indexing
	description: "Objects that analyze a SUDOKU object and give (if possible) the solution to it."
	author: "F. Lauffenburger"
	date: "$Date$"
	revision: "$Revision$"

class
	SOLVERBRAIN
create
	do_the_stupid_stuff
feature {SOLVERBRAIN}--Access brain only
	solvehelp :ARRAY3[INTEGER]  --3D matrix used to solve stuff
	solvenumbers:ARRAY[INTEGER] --added to help me think, matrix with numbers that should be looked at to solve.
feature -- Access (solution)
	solveddone:ARRAY2ENH --final sudoku solved and all.
feature -- Basic Analyzers (creation)
	do_the_stupid_stuff (sud: SUDOKU) is
			-- Basica analyzer that places 1's at the spots where there are numbers, precursor to more sophisticated stuff must be run first!
		local x,y,z:INTEGER
		do
			create solvehelp.make (9,9,9)
			create solvenumbers.make (1,9)
			if solveddone=void then
				make_solvedone(sud)
			end
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
					if sud.sudoku_matrix.item (x,y)>0 then
						from
							z:=1
						until
							z>9
						loop
							solvehelp.put (1,x,y,z)
							z:=z+1
						end
					else
						from
							z:=1
						until
							z>9
						loop
							solvehelp.put(0, x, y, z)
							z:=z+1
						end
					end
					y:=y+1
				end
				x:=x+1
			end
		end
feature --2D Array features
	rip_2d (plane:INTEGER):ARRAY2ENH is
			-- Array that "rips" the plane # array out of the 3D matrix and returns it.
		local x,y :INTEGER
		do
			create Result.make (9,9)
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
					Result.put (solvehelp.item (x, y, plane), x, y)
					y:=y+1
				end
				x:=x+1
			end
		end
	put_2d (plane:INTEGER ; some_array: ARRAY2ENH) is	
			-- puts some_array into the solvematrix at Z=plane
		local x,y:INTEGER
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
					solvehelp.put(some_array.item(x,y), x, y, plane)
					y:=y+1
				end
				x:=x+1
			end
		end
	changesudoku (sud:SUDOKU) is
			-- Changes the content of the 2dim array in "sud" to the contents of solveddone (which may be an intermediary step not the complete solution!!)
			local x, y:INTEGER
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
						sud.sudoku_matrix.put(solveddone.item(x,y),x,y)
						y:=y+1
					end
					x:=x+1
				end
			end
		
feature -- Analysis of given data.
	straight_check (sud: SUDOKU) is		
			-- Does a basic straight check of all numbers, fills the solverhelp
		local x,y,z, temp, findthatsplit:INTEGER ; temprip:ARRAY2ENH ; full_no_splittet:SPLITTET --tons of locals!! fun! this means a ton of nested loops, oh joy!
		do
			create full_no_splittet.make (3, 3)
			full_no_splittet.fillsplit (1)
			from
				z:=1
			until
				z>9
			loop
				temprip:=rip_2d(z)
				from
					y:=1
				until
					y>9
				loop
					from
						x:=1
					until
						x>9
					loop
					if sud.sudoku_matrix.item (x, y)= z then --We found a number that has been set, time to fill out where we can NOT place it due to this fact
						from
							temp:=1
						until
							temp>9
						loop
							temprip.put (1, temp, y)
							temprip.put (1, x, temp)
							findthatsplit:=0
							findthatsplit:=findthatsplit+((x+2)//3)+(((y-1)//3)*3)  --this should give a valid split value
							temprip.ack_undo_split (findthatsplit, full_no_splittet)
							temp:=temp+1
						end
					end
					x:=x+1
					end
					y:=y+1
				end
				put_2d(z, temprip)
				z:=z+1
			end
		end
	splittet_analysis (sud:SUDOKU) is	
			-- Checks the splittets if there is a possibility of further analysis
			-- this occurs if there are 3 or less "free" spots for the number in the 
			-- splittet. If these are ALSO in the same line, we can consider that line elsewhere to be impossible
		local ziterator, splitcounter, occount :INTEGER;tempsplit: SPLITTET ; temprip: ARRAY2ENH
		do
			
			from
				ziterator:=1
			until
				ziterator>9
			loop
				temprip:=rip_2d(ziterator) -- Getting the plane to analyze
				from
					splitcounter:=1
				until
					splitcounter>9
				loop
					tempsplit:=temprip.split (splitcounter)
					if tempsplit.occurrences (0)<=3 and tempsplit.occurrences(0) > 1 then --dang, found a splitter requiring analysis, for a better view of what is happening I 
					tempsplit.gimme_1st_occurrence (0)
					from
					tempsplit:=temprip.split (splitcounter) --got split to analyze
					occount:=0
					until
						occount=tempsplit.occurrences (0)
					loop
						if tempsplit.occurrences (0)= 3 then
							if (tempsplit.y_found=1) and (tempsplit.item(tempsplit.x_found, tempsplit.y_found+1)=0 and tempsplit.item(tempsplit.x_found, tempsplit.y_found+2)=0) then
								fillcolumn (ziterator, splitcounter, tempsplit)
								elseif tempsplit.x_found=1 and (tempsplit.item(tempsplit.x_found+1, tempsplit.y_found)=0 and tempsplit.item(tempsplit.x_found+2, tempsplit.y_found)=0) then
								fillrow(ziterator, splitcounter, tempsplit)	
							end
						end
						if tempsplit.occurrences (0) = 2 then
							if (tempsplit.x_found <= 2) and (tempsplit.item(tempsplit.x_found+1, tempsplit.y_found)=0) then
								fillrow(ziterator, splitcounter, tempsplit)
							end
							if (tempsplit.y_found <=2) and (tempsplit.item(tempsplit.x_found, tempsplit.y_found+1)=0) then
								fillcolumn(ziterator, splitcounter, tempsplit)
							end
							if (tempsplit.x_found =1) and (tempsplit.item (tempsplit.x_found+2, tempsplit.y_found)=0) then
								fillrow(ziterator, splitcounter, tempsplit)
							end
							if (tempsplit.y_found =1) and (tempsplit.item (tempsplit.x_found, tempsplit.y_found+2)=0) then
								fillrow(ziterator, splitcounter, tempsplit)
							end
						end
						occount:=occount+1
					end
					end
					splitcounter:=splitcounter+1
				end
				ziterator:=ziterator+1
			end
		end
feature --Fill column, fill row with "no" except the splitter received.
	fillcolumn (plane_no, split_no:INTEGER;splitter:SPLITTET) is
			-- fills the column
		local temprip: ARRAY2ENH; tempsplit : SPLITTET; y, realx:INTEGER
		do
			temprip:=rip_2d(plane_no)
			tempsplit:=temprip.split (split_no)
		from
			realx:=(split_no-1)*3+splitter.x_found --find the "real" x value of the splittet
			y:=3
		until
			(realx<=3)
		loop
			realx:=((split_no-y)-1)*3+splitter.x_found
			y:=y+3
		end
		from
			y:=1
		until
			y>9
		loop
			temprip.put (1, realx, y)
			y:=y+1
		end
		temprip.ack_undo_split (split_no,splitter)
		put_2d (plane_no, temprip)
		end
	fillrow (plane_no, split_no:INTEGER; splitter:SPLITTET) is
			-- fills the row
		local temprip: ARRAY2ENH; tempsplit: SPLITTET; x, realy:INTEGER
		do
			temprip:=rip_2d(plane_no)
			tempsplit:=temprip.split (split_no)
			realy:=(((split_no-1)//3) * 3)  + splitter.y_found
			from
				x:=1
			until
				x>9
			loop
				temprip.put (1, x, realy)
				x:=x+1
			end
			temprip.ack_undo_split (split_no,splitter)
			put_2d (plane_no, temprip)
		end
feature --Fill the *hintlist*
	hint(sud:SUDOKU):ARRAY[INTEGER] is
			-- fills teh hintlist (solvenumbers)
		local counter :INTEGER
		do
			do_the_stupid_stuff (sud)
			straight_check(sud)
			splittet_analysis(sud)
			create Result.make(1,9)
			from
				counter:=1
			until
				counter>9
			loop
				if is_he_the_one(counter) then
					solvenumbers.put(counter, counter)
					Result.put(counter, counter)
					else
					solvenumbers.put(0,counter)
					Result.put(0,counter)
				end
				counter:=counter+1
			end
		end
	is_he_the_one(some_value:INTEGER):BOOLEAN is
			-- checks if there is a one time solution for "some_value"
		local some_matrix:ARRAY2ENH; counter:INTEGER
		do	
			some_matrix:=rip_2d(some_value)
			from
				counter:=1
				Result:=False
			until
				(counter>9) or (Result=True)
			loop
				if (some_matrix.split (counter).occurrences (0)=1)or (some_matrix.gimmecolumn (counter).occurrences (0)=1) or (some_matrix.gimmerow (counter).occurrences (0)=1) then
					Result:=True
				end
				counter:=counter+1
			end
			
		end
feature --Other functions
	make_solvedone(sud:SUDOKU) is
			-- makes solvedone
		local x, y:INTEGER
		do
			create solveddone.make (9,9)
			from
				y:=1
			until
				y>9
			loop
				from
					x:=1
				until
					x>9
				loop
					solveddone.put(sud.sudoku_matrix.item(x, y), x, y)
					x:=x+1
				end
				y:=y+1
			end
		end
		
	complete_solution (sud:SUDOKU) is
			-- solves it (i hope)
		do
			from
				
			until
				hint(sud).occurrences (0)=9
			loop
			do_the_stupid_stuff (sud)
			straight_check(sud)
			splittet_analysis(sud)
			fill_what_you_can (sud)
--			solveddone.print_it
			changesudoku (sud)
--			io.new_line
			end
		end
		
	fill_what_you_can (sud:SUDOKU) is
			-- fills what he can, returns the filled as a solution
		local x,anothercounter,yetanothercounter:INTEGER;somematrix:ARRAY2ENH
		do
			from
				x:=1
			until
				x>9
			loop
				if is_he_the_one(x) then
					from
						anothercounter:=1
					until
						anothercounter>9
					loop
						somematrix:=rip_2d(x)
						if (somematrix.split (anothercounter).occurrences (0)=1) then
							solveddone.ack_undo_split (anothercounter, somematrix.split(anothercounter).mangle_split (anothercounter, solveddone.split (anothercounter)))
						end
						if somematrix.gimmecolumn (anothercounter).occurrences (0)=1 then
							from
								yetanothercounter:=1
							until
								yetanothercounter>9
							loop
								if somematrix.item (anothercounter, yetanothercounter)=0 then
									solveddone.put(x,anothercounter, yetanothercounter)
								end
								yetanothercounter:=yetanothercounter+1
							end
						end
						if somematrix.gimmerow (anothercounter).occurrences (0)=1 then
							from
								yetanothercounter:=1
							until
								yetanothercounter>9
							loop
								if somematrix.item(yetanothercounter, anothercounter)=0 then
									solveddone.put(x, yetanothercounter, anothercounter)
								end
								yetanothercounter:=yetanothercounter+1
							end
						end
						anothercounter:=anothercounter+1
					end

				end
				x:=x+1
			end
		end
		
feature --Test
	test (sud:SUDOKU)is		
			-- tests
		local z:INTEGER
		do
			
			
			from
				z:=1
			until
				z>9
			loop
				rip_2d(z).print_it
				io.new_line
				z:=z+1
			end
		end
		
		
end
