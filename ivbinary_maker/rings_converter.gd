# rings_converter.gd
# This file is part of I, Voyager
# https://ivoyager.dev
# *****************************************************************************
# Copyright 2017-2023 Charlie Whitfield
# I, Voyager is a registered trademark of Charlie Whitfield in the US
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *****************************************************************************
class_name RingsConverter
extends RefCounted

# Data files from https://bjj.mmedia.is/data/s_rings/.

signal status(message)


# import
const SOURCE_PATH := "res://source_data/rings/"
const COLOR_FILE := "color.txt"
const TRANSPARENCY_FILE := "transparency.txt"
const BACKSCATTERED_FILE := "backscattered.txt"
const FORWARDSCATTERED_FILE := "forwardscattered.txt"
const UNLITSIDE_FILE := "unlitside.txt"

# export
const EXPORT_PREFIX := "res://ivbinary_export/rings/saturn.rings"
const BACKSCATTER_FORMAT := ".backscatter.%s.png"
const FORWARDSCATTER_FORMAT := ".forwardscatter.%s.png"
const UNLITSIDE_FORMAT := ".unlitside.%s.png"

const UNLIT_COLOR := Color(1.0, 0.97075, 0.952)
const FORWARD_REDSHIFT := 0.05
const END_PADDING := 0.05 # saved image is 10% bigger
const LOD_LEVELS := 9


var color: Array[Color] = [] # lit side
var transparency: Array[float] = [] # inverted alpha
var backscattered: Array[float] = []
var forwardscattered: Array[float] = []
var unlitside: Array[float] = []

var backscattered_map: Array[Color] = []
var forwardscattered_map: Array[Color] = []
var unlitside_map: Array[Color] = []



func convert_data() -> void:
	_read_data()
	_make_color_maps()
	for lod in LOD_LEVELS:
		_make_lod_images(lod)
	status.emit("Generated rings textures: base width = %s; lod = %s" % [backscattered_map.size(),
			LOD_LEVELS])


func _read_data() -> void:
	var file := FileAccess.open(SOURCE_PATH + COLOR_FILE, FileAccess.READ)
	if !file:
		print("Failed to open file for read: ", SOURCE_PATH + COLOR_FILE)
		return
	
	# color
	color.clear()
	var file_length := file.get_length()
	while file.get_position() < file_length:
		var line: String = file.get_line()
		var values := line.split_floats("\t", false)
		color.append(Color(values[0], values[1], values[2]))
	
	# all others
	for file_name in [
			TRANSPARENCY_FILE,
			BACKSCATTERED_FILE,
			FORWARDSCATTERED_FILE,
			UNLITSIDE_FILE,
	] as Array[String]:
		file = FileAccess.open(SOURCE_PATH + file_name, FileAccess.READ)
		var array: Array[float] = get(file_name.get_basename())
		array.clear()
		if !file:
			print("Failed to open file for read: ", SOURCE_PATH + file_name)
			return
		file_length = file.get_length()
		while file.get_position() < file_length:
			var line: String = file.get_line()
			var value := float(line)
			array.append(value)
		assert(array.size() == color.size())


func _make_color_maps() -> void:
	# w/ padding
	backscattered_map.clear()
	forwardscattered_map.clear()
	unlitside_map.clear()
	var rings_width: int = color.size()
	var padding: Array[Color] = Array([], TYPE_COLOR, &"", null)
	padding.resize(roundi(END_PADDING * rings_width))
	padding.fill(Color(0.0, 0.0, 0.0, 0.0))
	backscattered_map.append_array(padding)
	forwardscattered_map.append_array(padding)
	unlitside_map.append_array(padding)
	for i in rings_width:
		var alpha := 1.0 - transparency[i]
		backscattered_map.append(Color(color[i] * backscattered[i], alpha))
		forwardscattered_map.append(Color(color[i] * forwardscattered[i], alpha))
		unlitside_map.append(Color(UNLIT_COLOR * unlitside[i], alpha))
	backscattered_map.append_array(padding)
	forwardscattered_map.append_array(padding)
	unlitside_map.append_array(padding)


func _make_lod_images(lod: int) -> void:
	# Note: As of Godot 4.2.x, a saved Texture2DArray was not recognized by editor importer.
	# We save png images instead and expect ivoyager_core to build the Texture2DArrays.
	var map_width := backscattered_map.size()
	var sample_width := 1 << lod
	var image_width := roundi(float(map_width) / float(sample_width))
	
	var backscattered_image := Image.create_empty(image_width, 1, false, Image.FORMAT_RGBA8)
	var forwardscattered_image := Image.create_empty(image_width, 1, false, Image.FORMAT_RGBA8)
	var unlitside_image := Image.create_empty(image_width, 1, false, Image.FORMAT_RGBA8)
	
	for i in image_width:
		var start := i * sample_width
		var stop := mini(start + sample_width, map_width)
		backscattered_image.set_pixel(i, 0, _get_color(backscattered_map, start, stop))
		forwardscattered_image.set_pixel(i, 0, _get_color(forwardscattered_map, start, stop))
		unlitside_image.set_pixel(i, 0, _get_color(unlitside_map, start, stop))
	
	backscattered_image.save_png(EXPORT_PREFIX + BACKSCATTER_FORMAT % lod)
	forwardscattered_image.save_png(EXPORT_PREFIX + FORWARDSCATTER_FORMAT % lod)
	unlitside_image.save_png(EXPORT_PREFIX + UNLITSIDE_FORMAT % lod)


func _get_color(map: Array[Color], start: int, stop: int) -> Color:
	var sample := Color(0.0, 0.0, 0.0, 0.0)
	var x := start
	while x < stop:
		sample += map[x]
		x += 1
	sample /= float(stop - start)
	return sample
