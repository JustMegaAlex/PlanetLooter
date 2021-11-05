
if is_showing_prompt_on and  is_showing_prompt {
	draw_text_above_me(ui_prompt_text)
	is_showing_prompt = false
}

if UI
	UI.draw_event()
