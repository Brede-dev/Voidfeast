extends Node

# Test script to verify speed upgrade system
func _ready() -> void:
	print("\n=== TESTING SPEED UPGRADE SYSTEM ===\n")
	
	# Test 1: Check GameManager has speed multiplier
	print("Test 1: GameManager speed_multiplier exists")
	print("  Current speed_multiplier: ", GameManager.speed_multiplier)
	print("  ✓ PASS\n" if GameManager.speed_multiplier == 1.0 else "  ✗ FAIL\n")
	
	# Test 2: Apply speed upgrade
	print("Test 2: Applying speed upgrade")
	GameManager.add_purchased_item("speed_upgrade")
	print("  Speed multiplier after purchase: ", GameManager.speed_multiplier)
	print("  ✓ PASS\n" if GameManager.speed_multiplier == 1.5 else "  ✗ FAIL\n")
	
	# Test 3: Check if purchased item is tracked
	print("Test 3: Speed upgrade marked as purchased")
	var is_purchased: bool = GameManager.is_item_purchased("speed_upgrade")
	print("  Is purchased: ", is_purchased)
	print("  ✓ PASS\n" if is_purchased else "  ✗ FAIL\n")
	
	# Test 4: Check speed multiplier persistence (save/load)
	print("Test 4: Speed multiplier saves and loads")
	GameManager.save_speed_upgrades()
	var old_multiplier: float = GameManager.speed_multiplier
	GameManager.speed_multiplier = 1.0  # Reset
	GameManager.load_speed_upgrades()
	print("  Loaded multiplier: ", GameManager.speed_multiplier)
	print("  ✓ PASS\n" if GameManager.speed_multiplier == 1.5 else "  ✗ FAIL\n")
	
	# Test 5: Verify Shop will show speed upgrade when 10+ items collected
	print("Test 5: Shop conditions for speed upgrade")
	GameManager.total_food_owned = 10
	var shop_will_show: bool = (GameManager.total_food_owned >= 10 and not GameManager.is_item_purchased("speed_upgrade"))
	print("  Total food owned: ", GameManager.total_food_owned)
	print("  Should show speed upgrade: ", shop_will_show)
	print("  ✓ PASS\n" if not shop_will_show else "  ✗ FAIL\n")  # Should be false since already purchased
	
	print("=== ALL TESTS COMPLETED ===\n")
	
	# Clean up
	queue_free()
