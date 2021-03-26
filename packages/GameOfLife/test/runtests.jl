using GameOfLife

println("Testing...")

@assert next_state(block_pattern) == block_pattern
@assert next_state(blinker_pattern_1) == blinker_pattern_2
@assert next_state(blinker_pattern_2) == blinker_pattern_1
	