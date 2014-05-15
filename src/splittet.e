indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SPLITTET
inherit
	ARRAY2[INTEGER]
create
	make
feature -- Access
	x_found: INTEGER
	y_found: INTEGER
	found_item: BOOLEAN
feature -- fill
	fillsplit (v:INTEGER) is
			-- fills splittet with v
		local x, y:INTEGER
		do
			from	
				x:=1
			until
				x>3
			loop
				from
					y:=1
				until
					y>3
				loop
					put (v, x, y)
					y:=y+1
				end
				x:=x+1
			end
		end		
feature --Operations
	gimme_1st_occurrence(wanted_value:INTEGER) is
			-- returnsX coordinate of 1st occurrence of y

		require
			item_does_exist: occurrences (wanted_value)>0
		local x, y:INTEGER
		do
			found_item:=False
			from
				y:=1
			until
				y>3
			loop
				from
					x:=1
				until
					x>3
				loop
					if (item(x, y)=wanted_value and found_item) then
						x_found:=x
						y_found:=y
						found_item:=True
					end
					x:=x+1
				end
				y:=y+1
			end
		ensure found_summat: found_item=True
		end
	find_next_occurrence(wanted_value:INTEGER) is
			-- finds the next location
		require
			did_you_run_1st: found_item=True
		local x, y:INTEGER
		do
			found_item:=False
			from
				y:=y_found
				if x_found=3 then
					y:=y+1
				end
			until
				y>3
			loop
				from
					if x_found=3 then
						x:=1
					else
						x:=x+1
					end
				until
					x>3
				loop
					if (item(x, y)=wanted_value and found_item) then
						x_found:=x
						y_found:=y
						found_item:=True
					end
					x:=x+1
				end
				y:=y+1
			end
		end
	mangle_split (v:INTEGER;original_split:SPLITTET):SPLITTET	is	
			-- takes the splittet from original, adds the number INT to the original SPLITTET received at the spot 0, from the performing widget
		do	
			gimme_1st_occurrence(0)
			original_split.put(v, x_found, y_found)
			Result:=original_split
		end
invariant
	please_3x3_only: (height<=3 and width <=3)
end
