#!/usr/bin/env python3
import sys

# Read the file
with open("D:/Voidfeast/Scenes/Level1.tscn", "r") as f:
    lines = f.readlines()

# Find the line with realblackhole and add pausemenu after it
found = False
for i, line in enumerate(lines):
    if 'realblackhole' in line and id="15_ubfni" in line:
        lines.insert(i+1, '[ext_resource type="PackedScene" path="res://Scenes/PauseMenu.tscn" id="16_pause"]\n')
        found = True
        break

# Find the last node and add PauseMenu node
if found:
    for i in range(len(lines)-1, -1, -1):
        if lines[i].strip().startswith('[node name="Node3D"') and 'realblackhole' in lines[i+1]:
            lines.insert(i+2, '\n[node name="PauseMenu" parent="." instance=ExtResource("16_pause")]\n')
            break

# Write back
with open("D:/Voidfeast/Scenes/Level1.tscn", "w") as f:
    f.writelines(lines)

print("Done!")
