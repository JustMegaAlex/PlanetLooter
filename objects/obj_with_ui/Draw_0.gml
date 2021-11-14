
if is_showing_prompt_on and  is_showing_prompt {
	draw_text_above_me(ui_prompt_text)
	is_showing_prompt = false
}

if UI
	UI.draw_event()

if displaying_timer > 0 {
	draw_text_custom(x, y + text_yoffset, display_text, fnt, fa_center, fa_middle)
}
