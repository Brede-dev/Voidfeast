# Speed Upgrade System - Testing Checklist

## ✅ Pre-Test Verification

- [ ] All 4 scripts modified:
  - [ ] res://Scripts/GameManager.gd (96 lines)
  - [ ] res://Scripts/player.gd (68 lines)
  - [ ] res://Scripts/Shop.gd (36 lines)
  - [ ] res://Scripts/SellThing.gd (54 lines)

- [ ] Documentation created:
  - [ ] SPEED_UPGRADE_SYSTEM.md
  - [ ] IMPLEMENTATION_SUMMARY.md
  - [ ] QUICK_START_SPEED_UPGRADE.md
  - [ ] TESTING_CHECKLIST.md

## 🎮 Functional Tests

### Test 1: Initial State
**Objective**: Verify the game starts with normal speed

Steps:
- [ ] Start a new game
- [ ] Play in first level
- [ ] Movement feels at normal speed
- [ ] Check console shows no speed upgrade errors

Expected: Game runs normally with speed = 5.0

### Test 2: Item Collection
**Objective**: Verify items can be collected and counted

Steps:
- [ ] Play level and collect items
- [ ] Count items collected
- [ ] Verify GameManager.total_food_owned increments
- [ ] Collect up to 10 items total

Expected: Items counter increases, reaches 10

### Test 3: Shop Appearance
**Objective**: Verify Speed Boost card appears in shop

Steps:
- [ ] Visit shop with exactly 10+ items collected
- [ ] Look for "Speed Boost" card
- [ ] Verify it shows cost of 10 items
- [ ] Verify it's not purchased (should be clickable)

Expected: Speed Boost card visible in shop

### Test 4: Purchase
**Objective**: Verify purchase mechanics work

Steps:
- [ ] In shop with 10+ items and Speed Boost available
- [ ] Click the Speed Boost card
- [ ] Verify cost is deducted (items -= 10)
- [ ] Verify card disappears from shop
- [ ] Check console for upgrade message

Expected: Cost deducted, card removed, console shows upgrade

### Test 5: Speed Increase
**Objective**: Verify movement is faster

Steps:
- [ ] After purchasing Speed Boost, return to game
- [ ] Try moving the same distance as before
- [ ] Movement should be noticeably faster
- [ ] Compare speed: should be 50% faster

Expected: Player moves 50% faster (7.5 instead of 5.0)

### Test 6: Persistence
**Objective**: Verify upgrade persists across sessions

Steps:
- [ ] Purchase Speed Boost
- [ ] Quit game completely
- [ ] Restart game
- [ ] Return to shop with 0+ items
- [ ] Speed Boost card should NOT appear (already purchased)
- [ ] Verify movement is still fast

Expected: Speed persists, card doesn't re-appear

### Test 7: Multiple Levels
**Objective**: Verify speed works across levels

Steps:
- [ ] Purchase Speed Boost in first level
- [ ] Progress to second level
- [ ] Verify movement is still fast
- [ ] Progress to third level (if exists)
- [ ] Verify movement still fast

Expected: Speed upgrade applies to all levels

### Test 8: Reset Button
**Objective**: Verify restart clears upgrades

Steps:
- [ ] Purchase Speed Boost (verified by fast movement)
- [ ] Go to shop and click Restart button
- [ ] Confirm reset (if applicable)
- [ ] Play new game
- [ ] Movement should be normal speed again
- [ ] Collect 10 items
- [ ] Speed Boost card should reappear in shop

Expected: Speed reset, card available again

## 🐛 Edge Case Tests

### Test 9: No Items Collected
**Objective**: Verify Speed Boost doesn't appear with < 10 items

Steps:
- [ ] Start game without collecting 10 items
- [ ] Go to shop
- [ ] Speed Boost should NOT appear

Expected: Card not visible when < 10 items

### Test 10: Already Purchased
**Objective**: Verify purchased item doesn't reappear

Steps:
- [ ] Collect 10 items
- [ ] Purchase Speed Boost
- [ ] Leave and return to shop multiple times
- [ ] Speed Boost should never reappear

Expected: Card never reappears after purchase

### Test 11: Exact 10 Items
**Objective**: Verify card appears at exactly 10 items

Steps:
- [ ] Collect items until exactly 10
- [ ] Go to shop
- [ ] Speed Boost should appear

Expected: Card visible at exactly 10 items

### Test 12: Multiple Purchases (Negative)
**Objective**: Verify Speed Boost can only be purchased once

Steps:
- [ ] Try clicking Speed Boost twice quickly
- [ ] Only one deduction should occur
- [ ] Card should disappear after first click

Expected: Only one purchase possible

## 📊 Performance Tests

### Test 13: Frame Rate
**Objective**: Verify no performance degradation

Steps:
- [ ] Check FPS before purchase
- [ ] Check FPS after purchase
- [ ] Compare FPS with and without speed upgrade

Expected: No FPS drop, consistent performance

### Test 14: Save File Size
**Objective**: Verify save file isn't too large

Steps:
- [ ] Purchase Speed Boost
- [ ] Check user://speed_upgrades.save file size
- [ ] Should be < 100 bytes

Expected: Minimal save file size

## 🎯 Integration Tests

### Test 15: With Other Shop Items
**Objective**: Verify Speed Boost works with existing items

Steps:
- [ ] Speed Boost appears alongside other shop items
- [ ] Other items still purchasable
- [ ] Speed Boost doesn't interfere with others

Expected: All items work together

### Test 16: After Level Completion
**Objective**: Verify speed works after winning level

Steps:
- [ ] Beat level with speed boost
- [ ] Progress to next level
- [ ] Speed boost still active

Expected: Speed persists through level completion

### Test 17: Parallel to Other Upgrades
**Objective**: Verify speed upgrade doesn't conflict

Steps:
- [ ] If other upgrades exist, verify they work with speed boost
- [ ] Both upgrades should be applicable together
- [ ] No conflicts or crashes

Expected: No conflicts with other systems

## 📝 Console Output Tests

### Test 18: Upgrade Message
**Objective**: Verify console logging works

Steps:
- [ ] Purchase Speed Boost
- [ ] Check console output
- [ ] Should see: "Speed upgraded! New multiplier: 1.5 New speed: 7.5"

Expected: Console message appears

### Test 19: No Error Messages
**Objective**: Verify no errors during operation

Steps:
- [ ] Perform all tests above
- [ ] Check console for error messages
- [ ] Should only see upgrade message, no errors

Expected: No error messages in console

## 🔄 Save/Load Tests

### Test 20: Save File Creation
**Objective**: Verify files are created correctly

Steps:
- [ ] Purchase Speed Boost
- [ ] Check user:// directory for speed_upgrades.save
- [ ] File should exist and contain data

Expected: Save file created at user://speed_upgrades.save

### Test 21: Load on Startup
**Objective**: Verify loaded speed persists

Steps:
- [ ] Purchase Speed Boost
- [ ] Quit game
- [ ] Restart game
- [ ] Without collecting items, movement should be fast
- [ ] Verify speed_multiplier is 1.5

Expected: Speed loads from save file automatically

### Test 22: Delete Save File
**Objective**: Verify game handles missing save

Steps:
- [ ] Purchase Speed Boost
- [ ] Delete user://speed_upgrades.save manually
- [ ] Restart game
- [ ] Game should load default speed_multiplier = 1.0
- [ ] No errors should occur

Expected: Game handles missing file gracefully

## 🎬 User Experience Tests

### Test 23: Visual Feedback
**Objective**: Verify player recognizes the upgrade

Steps:
- [ ] Purchase Speed Boost
- [ ] Return to game
- [ ] Notice movement is 50% faster
- [ ] Recognize the upgrade was successful

Expected: Clear visual/tactile feedback of speed increase

### Test 24: UI Clarity
**Objective**: Verify Speed Boost card is clear

Steps:
- [ ] Look at Speed Boost card in shop
- [ ] Card should be clearly labeled "Speed Boost"
- [ ] Cost should be clearly visible (10 items)
- [ ] Card should be clickable when affordable

Expected: Clear, intuitive UI

### Test 25: Consistent Behavior
**Objective**: Verify system behaves predictably

Steps:
- [ ] Perform any test multiple times
- [ ] Behavior should be consistent
- [ ] No random failures or bugs

Expected: Consistent, reliable behavior

## 📋 Final Checklist

Before declaring complete:
- [ ] All 25 tests passed
- [ ] No error messages in console
- [ ] No performance issues
- [ ] Speed upgrade appears correctly
- [ ] Speed upgrade costs correct amount
- [ ] Speed multiplier is 1.5 (not more, not less)
- [ ] Speed persists across sessions
- [ ] Can't purchase twice
- [ ] Reset clears upgrade
- [ ] Documentation is accurate
- [ ] Code follows existing patterns
- [ ] No breaking changes to other systems

## 🎉 Sign-Off

- Tested by: ________________
- Date: ________________
- Result: ________________
- Notes: ________________

**Status**: ☐ PASSED ☐ FAILED

If failed, list issues:
1. _________________________
2. _________________________
3. _________________________
