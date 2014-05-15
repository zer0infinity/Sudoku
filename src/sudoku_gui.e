indexing

	description: "[

		Little Sudoku Assistant

	]"
	date: "$Date$"
	revision: "$Revision$"

class SUDOKU_GUI

inherit

	EM_APPLICATION

create

	make

feature {NONE} -- Initialisation

	make is
			-- Start main application.
		local
			keyboard: EM_KEYBOARD
		do
			-- Initiliase subsystems
			Video_subsystem.set_video_surface_width (Window_width)
			Video_subsystem.set_video_surface_height (Window_height)
			Video_subsystem.set_video_bpp (Screen_resolution)
			Video_subsystem.set_fullscreen (Is_fullscreen_enabled)
			Video_subsystem.enable
			Audio_subsystem.enable

			initialize_screen

			-- Check subsystem initialisation
			if
				Video_subsystem.is_enabled and
				Audio_subsystem.is_enabled
			then

				-- Set global options
				set_window_title (" ¿ Little Sudoku Assistant ?")
				set_application_id ("sudoku_gui")
				set_window_icon ("./image/icon.jpg")

				create keyboard.make_snapshot
				keyboard.enable_unicode_characters
				keyboard.disable_repeating_key_down_events
			
				-- Set first scene and launch it
				set_scene (create {SPLASH}.make)
				launch

				-- Disable subsystems
				Video_subsystem.disable
				Audio_subsystem.disable
			else
				if not Video_subsystem.is_enabled then
					io.error.put_string ("Failed to initialise video subsystem.%N")
				end
				if not Audio_subsystem.is_enabled then
					io.error.put_string ("Failed to initialise audio subsystem.%N")
				end
			end
		end
		
feature {NONE} -- Implementation

	Window_width: INTEGER is 800
			-- Window width

	Window_height: INTEGER is 650
			-- Window height

	Screen_resolution: INTEGER is 32
			-- Screen resolution

	Is_fullscreen_enabled: BOOLEAN is False
			-- Is fullscreen enabled?
end
