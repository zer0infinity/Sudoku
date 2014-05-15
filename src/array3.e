indexing
	description: "3 Dimensional Matrix somewhat generalized to allow reuse however specifically designed for SUDOKUs"
	author: "F. Lauffenburger, D. Tran"
	date: "24.12.05"
	revision: "1.0"

class
	ARRAY3 [G]
inherit ARRAY [G]
		rename
			make as array_make,
			item as array_item,
			put as array_put
		export
			{NONE}
				array_make
			{ARRAY3}
				array_put, array_item
		end
create
	make

feature --Creation
	make (a, b, c:INTEGER) is
			-- Create matrix with a,b,c dimensions
	require
		don_t: a > 0
		give_me:b>0
		bad_values:c>0
	do		
		height := a
		width := b
		depth := c
		array_make (1, height*width*depth)
	ensure
		new_count: count=height*width*depth
	end
	initialize (v: G) is
			-- Fills matrix with v
		local
			x, y, z: INTEGER
		do
			from
				x:=1
			until
				x>height
			loop
				from
					y:=1
				until
					y>width
				loop
					from
						z:=1
					until
						z>depth
					loop
						put (v, x, y, z)
						z:=z+1
					end
				y:=y+1
				end
			x:=x+1
			end
		end	

feature --Measurement
	height: INTEGER
	width: INTEGER
	depth: INTEGER

feature --Access
	item (x,y,z:INTEGER): G is
			-- Get value of item at x, y, z
		require
			good_x: (1<=x) and (x<=height)
			good_y: (1<=y) and (y<=width) --Checking if values are within the matrix dimensions
			good_z: (1<=z) and (z<=depth)
		do
			Result:= array_item (((z-1)*width*height)+((y-1)*height)+x)
		end
feature --Element change
	put (v: like item; x, y, z: INTEGER) is
			-- Puts "v" at x, y, z
		require
			good_x: (1<=x) and (x<=height)
			good_y: (1<=y) and (y<=width) --Checking if values are within the matrix dimensions
			good_z: (1<=z) and (z<=depth)
		do
			array_put (v, ((z-1)*width*height)+((y-1)*height)+x)
		end
end
