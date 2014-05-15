indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FIELD
	
inherit
   EM_TEXTBOX
		redefine
			handle_key_down
		end

create
	make_empty

feature -- Event Handling

	handle_key_down (keyboard: EM_KEYBOARD_EVENT) is
			-- do some stupid thing when a key is "gedrückt"
		do
			Precursor {EM_TEXTBOX} (keyboard)
			if text.count > 1 then
				set_text (text.substring (1, 1))
			end
			if (not text.is_integer) or text.to_integer=0 then
				set_text("")
			end
		end
end
