# ivbinary_maker.gd
# This file is part of I, Voyager
# https://ivoyager.dev
# *****************************************************************************
# Copyright 2017-2024 Charlie Whitfield
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
extends RefCounted

# This file modifies ivoyager_core & ivoyager_table_importer operation.
#
# v0.3.dev exports data for ivoyager_core v0.0.19.dev (Godot 4.3)
# v0.2 exports data for ivoyager/ivoyager_core v0.0.16 to .18 (Godot 4.x).
# v0.1 exports data for ivoyager v0.0.14 to .15 (Godot 3.x).

const USE_THREADS := true # set false for debugging
const DISABLE_THREADS_IF_WEB := true # override for browser compatibility
const VERBOSE_GLOBAL_SIGNALS := false
const VERBOSE_STATEMANAGER_SIGNALS := false

# const EXTENSION_NAME := "ivbinary_maker"
# const EXTENSION_VERSION := "0.2"
# const EXTENSION_BUILD := ""
# const EXTENSION_STATE := "dev"
# const EXTENSION_YMD := 20230925


func _init() -> void:
	
	var version: String = ProjectSettings.get_setting("application/config/version")
	print("IVBinary Maker %s - https://ivoyager.dev" % version)
	
	if VERBOSE_GLOBAL_SIGNALS and OS.is_debug_build:
		IVDebug.signal_verbosely_all(IVGlobal, "Global")
	
	# Remove everything and add only what we need.
	IVCoreInitializer.initializers.clear()
	IVCoreInitializer.program_refcounteds.clear()
	IVCoreInitializer.program_nodes.clear()
	IVCoreInitializer.gui_nodes.clear()
	IVCoreInitializer.procedural_objects.clear()
	IVCoreInitializer.initializers[&"TableInitializer"] = IVTableInitializer
	
	# ivbinary_maker
	IVCoreInitializer.program_refcounteds[&"AsteroidsConverter"] = AsteroidsConverter
	IVCoreInitializer.program_refcounteds[&"RingsConverter"] = RingsConverter
	IVCoreInitializer.top_gui = IVFiles.make_object_or_scene(GUI)
