--Container Fillers (NWN2)

--Version 1.0

--Version History:
2-7-2009	1.0	-initial release

--Contents:
	This package contains 7 basic geometric placeables, 21 base textures, and 12 texture swapping VFX. The purpose of this pack is to provide an easier way to fill non rectangle containers with various substances like water, instead of having to rely on billboards or the exterior texturing tools.The models can be used on their own as well for various props or special effects.

--How to set up for use:

[bom_containerfillers_v10.rar]
Extract the contents of bom_containerfillers_v10.rar into a temporary working directory.

Copy the contents of placeables_2DA_stub.txt and append them to the end of your module's placeables.2da file.

Move all the .sef, .tga, and .mdb files either into your module/campaign working directory, or add them to your module's hak pack.


[bom_cfiller_demomod.rar]
This archive contains a one room demo module demonstrating some of the various forms and vfx in use.

Extract this file into your MyDocuments/NWN2/Modules directory.

[bom_cfiller_layouts.rar]
This archive contains texture assets showing the uv layouts of all the primitive forms included with this pack. Use these grids in your 2d drawing program when you want to custom tailor a new texture to a specific model.

--Parts list:

[Shapes - 2DA entry names listed]
FormSphere01	- 16 segment sphere
FormCylinderN3	- 3 sided cylinder
FormSquare01	- cube
FormCylinderN5	- 5 sided cylinder
FormCylinderN6	- 6 sided cylinder
FormCylinderN8	- 8 sided cylinder
FormCylinderN24	- 24 sided cylinder

[VFX]
texture_swap_dirt 		- 3 tints (soild, rough rock, crumbly cheese)
texture_Swap_filament 		- 3 tints, translucent (thick webbing, fibrous mold)
texture_swap_grain 		- 1 tint (porridge, grain, beans, insect eggs)
texture_swap_gravel 		- 1 tint (gravel, riverbed rock, wall)
texture_swap_jello 		- 1 tint, translucent (slime, jello)
texture_swap_magma 		- 3 tints (hot lava, cooling magma, fragmenting stone with a burning core)
texture_swap_plainglass 	- 1 tint, translucent (glass, crystal, force field)
texture_swap_sludge 		- 1 tint (blood, mud, tar, pudding)
texture_swap_stone 		- 3 tints (rough cut blocks and pillars, boulder traps)
texture_swap_straw 		- 1 tint 
texture_swap_translucent60 	- default tint, translucent
texture_swap_water 		- 1 tint, translucent (water, beer, urine)

--General usage guide:
Tinting works like a regular placeable. Just set the colors in the placeable's properties.

To change the textures on a placeable add one of the texture_swap_ vfx's to the object's appearance (special effect) slot.

Texture changes from a vfx won't be shown in the toolset, but they do work in game. 

The original diffuse alphas on an object will not get replaced by the vfx diffuse's alpha channel. I suspect this was hard coded in to prevent stoneskin/barkskin effects from messing up hair and body appearances. This means that it is not possible to get invisible form highlighting with just a vfx swap. 

Setting up existing stock placeables for use with texture vfx:
Open the placeable's mdb file using the MDB Cloner.
Turn on the alpha of the object.
Add bom_color1_t.tga to the tint slot if it is blank.
Add bom_blank_i.tga to the glow slot if it is blank.
Save the mdb and add as an override to your project.

--Permissions:
Anyone is allowed to repackage and/or modify the meshes and textures in this package as long as credit is given for the original source and the user does not charge money for their derived product.

--Credits:
Barrel of Monkeys based on a request posted by Dunniteowl in the NWN2 custom content forum
