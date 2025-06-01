extends Object

## Sync multipliers to current speed amount
func on_speed_changed(chain: ModLoaderHookChain, speed: float) -> void:
	chain.reference_object.multiplier.amount = maxf(0.0, (speed - 1.0) * 0.75)
	if chain.reference_object.multiplier.amount > 0.75:
		chain.reference_object.multiplier.amount = 0.75
