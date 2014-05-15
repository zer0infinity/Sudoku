indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAIN_GUI

inherit
	
	SOLVERBRAIN
	
	EM_WIDGET_SCENE
		redefine
			handle_quit_event
		end
	
	EM_SHARED_BITMAP_FACTORY
		export {NONE} all end

create

	make_gui

feature -- Initialisation

	make_gui is
			-- Initialise scene
		local
			x_counter, y_counter: INTEGER
		do
			create sudoku_input.make(9,9)
			make_widget_scene
			
			-- create background
			bitmap_factory.create_bitmap_from_image ("./image/background.jpg")
			create bitmap_background.make_from_bitmap (bitmap_factory.last_bitmap)
			set_background (bitmap_background)
			
			-- create widgets
			-- credits button
			create button.make_from_text ("Credits")
			button.set_position (480, 0)
			button.set_dimension (160, 25)
			button.clicked_event.subscribe (agent handle_credits_event)
			add_widget (button)
			
			-- quit window
			create m_dialog.make_from_question ("Do you really want to quit?")
			m_dialog.set_modal (True)
			m_dialog.set_title ("Trick Question:")
			m_dialog.yes_button.clicked_event.subscribe (agent quit)
			
			-- quit button
			create button.make_from_text ("Quit")
			button.set_position (640, 0)
			button.set_dimension (160, 25)
			button.clicked_event.subscribe (agent m_dialog.show)
			add_widget (button)

			-- solve button
			create button.make_from_text ("Solve")
			button.set_position (320, 0)
			button.set_dimension (160, 25)
			button.clicked_event.subscribe (agent handle_solve_event)
			add_widget (button)
			
			-- help button
			create button.make_from_text ("HELP!")
			button.set_position (160, 0)
			button.set_dimension (160, 25)
			button.clicked_event.subscribe (agent handle_help_event)
			add_widget (button)
			
			-- new window
			create m_dialog.make_from_question ("sure sure sure???")
			m_dialog.set_modal (True)
			m_dialog.set_title ("reset?")
			m_dialog.yes_button.clicked_event.subscribe (agent handle_new_event)
			
			-- new button
			create button.make_from_text ("New")
			button.set_position (0, 0)
			button.set_dimension (160, 25)
			button.clicked_event.subscribe (agent m_dialog.show)
			add_widget (button)
			
			-- status box
			create textbox.make_empty
			textbox.set_dimension (200, 100)
			textbox.set_position (620, 500)
			textbox.set_font (create {EM_TTF_FONT}.make_from_ttf_file ("vera.ttf", 20))
			textbox.set_transparent
			textbox.set_border (create {EM_LINE_BORDER}.make (create {EM_COLOR}.make_transparent, 0))
			add_widget (textbox)	
			status_field:=textbox		
			-- sudoku 9x9 input buttons
			from
				x_counter:=1
			until
				x_counter>9
			loop
				from
					y_counter:=1
				until
					y_counter>9
				loop
					create textbox.make_empty
					textbox.set_dimension (43, 43)
					textbox.set_position (185+((x_counter-1)*47), 169+((y_counter-1)*47))
					textbox.set_font (create {EM_TTF_FONT}.make_from_ttf_file ("vera.ttf", 40))
					textbox.set_transparent
					textbox.set_border (create {EM_LINE_BORDER}.make (create {EM_COLOR}.make_transparent, 0))
					add_widget (textbox)
					sudoku_input.put (textbox,x_counter,y_counter)
					y_counter:=y_counter+1
				end
			x_counter:=x_counter+1
			end			
		ensure
			bitmap_background_not_void: bitmap_background /= void
			font_not_void: a_font /= void
		end
			
feature -- Event handling

	handle_help_event is
			-- Gives a hint
		local
			dull_counter:INTEGER
			temptext:STRING
		do
			make_sudoku
			temptext:="Tip:"
			from
				dull_counter:=1
			until
				dull_counter>9
			loop
				if hint(sudsud).item (dull_counter)/=0 then
					temptext:=temptext + dull_counter.out + " "
				end
				dull_counter:=dull_counter+1
			end
			if temptext.is_equal("Tip:") then
				temptext:="Sorry"
			end
			status_field.set_text (temptext)
		end

	handle_solve_event is
			-- SOLVE IT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		do
			make_sudoku
			complete_solution(sudsud)
			print_sudoku
		end
	
	handle_quit_event (a_quit_event: EM_QUIT_EVENT) is
			-- Handle quit event.
		do
			
			create m_dialog.make_from_question ("Are you sure, or did you misclick?")
			m_dialog.set_modal (True)
			m_dialog.set_title ("Trick Question:")
			m_dialog.yes_button.clicked_event.subscribe (agent quit)
			m_dialog.show
		end
	
	handle_new_event is
			-- reset sudoku
		do
			make_sudoku
			new
		end

	handle_credits_event is
			-- Show Credits & Play Music
		do
			if credits_is_open = false then
				-- play music while credits windows is open
				create music_player.make_with_file ("./sound/music.mod", true)
				music_player.set_repeat (true)
				music_player.play
				
				-- credits window
				create dialog.make_from_title ("WTF?")
				dialog.set_background (create {EM_BITMAP_BACKGROUND}.make_from_file ("./image/credits.jpg"))
				dialog.set_position (188, 180)
				dialog.set_dimension (400, 300)
				dialog.show_close_button
				dialog.set_draggable (true)
				dialog.close_button_clicked_event.subscribe (agent music_player.stop)
				dialog.show
			else
				music_player.stop
				dialog.hide
			end
			credits_is_open := not credits_is_open
		end
	
feature {NONE} -- Implementation

	print_sudoku is
			-- prints sudoku from the SUDOKU class to the screen
		local
			x_counter, y_counter:INTEGER		
		do
			from	
				x_counter:=1
			until
				x_counter>9
			loop
				from
					y_counter:=1
				until
					y_counter>9
				loop
					if sudsud.sudoku_matrix.item (x_counter,y_counter)/=0 then
					sudoku_input.item(x_counter, y_counter).set_text(sudsud.sudoku_matrix.item(x_counter,y_counter).out)						
					else
						sudoku_input.item (x_counter,y_counter).set_text ("")
					end

					y_counter:=y_counter+1
				end
				x_counter:=x_counter+1
			end
		end

	make_sudoku is
			-- Makes sudoku from the input
		local
			x_counter, y_counter:INTEGER
		do
			create sudsud.make
			from
				x_counter:=1
			until
				x_counter>9
			loop
				from
					y_counter:=1
				until
					y_counter>9
				loop
					if sudoku_input.item(x_counter, y_counter).text.is_integer then
						sudsud.sudoku_matrix.put(sudoku_input.item(x_counter, y_counter).text.to_integer,x_counter,y_counter)
					end
					y_counter:=y_counter+1
				end
				x_counter:=x_counter+1
			end
		end
	
--	new is
--			-- New Button/ reset Sudoku
--		local
--			x_counter, y_counter: INTEGER		
--		do
--			from	
--				x_counter:=1
--			until
--				x_counter>9
--			loop
--				from
--					y_counter:=1
--				until
--					y_counter>9
--				loop
--					if sudsud.sudoku_matrix.item (x_counter,y_counter)/=0 then
--						sudoku_input.item (x_counter,y_counter).set_text ("")
--					end
--					y_counter:=y_counter+1
--				end
--				x_counter:=x_counter+1
--			end
--		end
		
	new is
			-- New button/ reset sudoku
			local x_counter, y_counter:INTEGER
	    do
	        from
	        	x_counter:=1
	        until
	        	x_counter>9
	        loop
	        	from
	        		y_counter:=1
	        	until
	        		y_counter>9
	        	loop
	        		sudsud.sudoku_matrix.put (0, x_counter, y_counter)
	        		y_counter:=y_counter+1
	        	end
	        	x_counter:=x_counter+1
	        end
	        print_sudoku
	    end

feature {NONE} -- Access

	sudoku_input: ARRAY2[FIELD]
		-- array of 81 textboxes
	
	status_field: EM_TEXTBOX
		-- Textbox
	
	sudsud: SUDOKU
		-- Instance of SUDOKU
	
	music_player: EM_MUSIC_PLAYER
		-- Music player
	
	bitmap_background: EM_BITMAP_BACKGROUND
		-- Background Bitmap
	
	button: EM_BUTTON
		-- Button
	
	dialog: EM_DIALOG
		-- Dialog
	
	m_dialog: EM_MESSAGE_DIALOG
		-- Message Dialog
	
	textbox: FIELD
		-- Instance of FIELD
	
	a_font: EM_COLOR_TTF_FONT
		-- Font
	
	a_string: EM_STRING
		-- String
		
	draw_panel: EM_DRAWABLE_PANEL
		-- Draw Panel
	
	credits_is_open: BOOLEAN
		-- is the credits window opened?
end
