using Colors


function to_rgb(s::Bool)
	if s 
		RGB(0, 0, 0)
	else
		RGB(1, 1, 1)
	end
end

function display_state(state::SimState) 
	map(to_rgb, state.data)
end
