indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SPLASH

inherit
	
	EM_WIDGET_SCENE
		
create

	make

feature -- Initialisation

	make is
		
		local
			button: EM_BUTTON
		do
			make_widget_scene

			-- create button with size of window
			create button.make_from_text (" ")
			button.set_position (0, 0)
			button.set_dimension (800, 650)
			button.set_delegate (create {EM_BASIC_PANEL_DELEGATE})
			button.set_border (create {EM_NO_BORDER})
			button.set_transparent
			button.set_background (create {EM_BITMAP_BACKGROUND}.make_from_file ("./image/start.jpg"))
			button.clicked_event.subscribe (agent start_main_gui)
			add_widget (button)

			-- play music
			create music_player.make_with_file ("./sound/start.mod", true)
			music_player.set_repeat (true)
			music_player.set_volume (90)
			music_player.play
		end

feature -- Start next Scene

	start_main_gui is

		do
			music_player.stop
			set_next_scene (create {MAIN_GUI}.make_gui)
			start_next_scene
		end

feature {NONE} -- Access

	music_player: EM_MUSIC_PLAYER
		-- Music Player
end
