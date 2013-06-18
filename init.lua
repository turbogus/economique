--Function

local function holospwan(pos, itemname)
	local obj = minetest.env:add_entity(pos, "mini_economique:item")
	obj:get_luaentity():set_item(itemname)
	return obj
end

function affichage (pos)
	local mitem1 = minetest.deserialize(minetest.env:get_meta(pos):get_string("item1"))
	local mitem2 = minetest.deserialize(minetest.env:get_meta(pos):get_string("item2"))
	local p = minetest.env:get_meta(pos):get_int("p")
	local pos = {x=pos.x,y=pos.y+1,z=pos.z}
	local listeobj=minetest.env:get_objects_inside_radius(pos, 0.60)
	if table.getn(listeobj)>=1 then
		for c=1,table.getn(listeobj) do
			if not(listeobj[c]:is_player()) then
				listeobj[c]:remove()
			end
		end
	end
	local hud={{0.33,0.10,0,0},{0,0,0.33,0.10},{-0.33,-0.10,0,0},{0,0,-0.33,-0.10}}
	local radians=(math.pi/2)*(p-1)
	local objet
	--Premier ligne
	if not(mitem1==nil) then
	holospwan({x=pos.x-hud[p][1],y=pos.y+0.33,z=pos.z-hud[p][3]},mitem1["name"])
	objet = minetest.env:add_entity({x=pos.x,y=pos.y+0.33,z=pos.z},"mini_economique:"..math.floor(mitem1["count"]/10).."")
	objet:setyaw(radians)
	objet = minetest.env:add_entity({x=pos.x+hud[p][2],y=pos.y+0.33,z=pos.z+hud[p][4]},"mini_economique:"..mitem1["count"]-(math.floor(mitem1["count"]/10)*10).."")
	objet:setyaw(radians)
	end
	if not(mitem2==nil) and not(mitem1==nil) then
	objet = minetest.env:add_entity({x=pos.x+hud[p][1],y=pos.y+0.33,z=pos.z+hud[p][3]},"mini_economique:buy")
	objet:get_luaentity():set_item({x=pos.x,z=pos.z,y=pos.y-1})
	objet:setyaw(radians)
	end
	--Deuxieme ligne
	if not(mitem2==nil) then
	holospwan({x=pos.x-hud[p][1],y=pos.y,z=pos.z-hud[p][3]},mitem2["name"])
	objet = minetest.env:add_entity({x=pos.x,y=pos.y,z=pos.z},"mini_economique:"..math.floor(mitem2["count"]/10).."")
	objet:setyaw(radians)
	objet = minetest.env:add_entity({x=pos.x+hud[p][2],y=pos.y,z=pos.z+hud[p][4]},"mini_economique:"..mitem2["count"]-(math.floor(mitem2["count"]/10)*10).."")
	objet:setyaw(radians)
	end
	if mitem2==nil then
	objet = minetest.env:add_entity({x=pos.x+hud[p][1],y=pos.y,z=pos.z+hud[p][3]},"mini_economique:rotation")
	objet:get_luaentity():set_item({x=pos.x,z=pos.z,y=pos.y-1})
	objet:setyaw(radians)
	end
end

--ABM

minetest.register_abm({
	nodenames = {"mini_economique:socle"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		local mitem1 = minetest.deserialize(minetest.env:get_meta(pos):get_string("item1"))
		local mitem2 = minetest.deserialize(minetest.env:get_meta(pos):get_string("item2"))
		if not(mitem2==nil) then
			local pos = {x=pos.x,y=pos.y+1,z=pos.z}
			local listeobj=minetest.env:get_objects_inside_radius(pos, 0.60)
			if table.getn(listeobj)==nil then
				holospwan(pos,mitem1["name"])
			end
		end
	end,
})


--Socle

minetest.register_node("mini_economique:socle", {
	description = "Socle holographique",
	drawtype = "node",
	tiles = {"wool_red.png", "wool_red.png", "default_tree.png"},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = true,
	groups = {dig_immediate=2},
	legacy_wallmounted = true,
	after_place_node = function(pos, placer)
		minetest.env:get_meta(pos):set_string("player",placer:get_player_name())
		minetest.env:get_meta(pos):set_string("item1","")
		minetest.env:get_meta(pos):set_string("item2","")
		minetest.env:get_meta(pos):set_int("p", 1)
	end,
	on_punch = function(pos, node, puncher)
		local mitem1 = minetest.deserialize(minetest.env:get_meta(pos):get_string("item1"))
		local mitem2 = minetest.deserialize(minetest.env:get_meta(pos):get_string("item2"))
		local item = puncher:get_wielded_item():to_table()
		if not(mitem2 == nil) then
			affichage(pos)
		else
			if not(item == nil) then
				if item["wear"] == 0 then
					if mitem1 == nil then
						minetest.env:get_meta(pos):set_string("item1",minetest.serialize(item))
						affichage (pos)
					elseif mitem2 == nil then
						minetest.env:get_meta(pos):set_string("item2",minetest.serialize(item))
						affichage (pos)
					end
				end
			end
		end
	end,
	can_dig = function(pos,player)
		local mplayer = minetest.env:get_meta(pos):get_string("player")
		return mplayer==player:get_player_name() or mplayer==""
	end,
	on_destruct = function(pos)
		local pos = {x=pos.x,y=pos.y+1,z=pos.z}
		local listeobj=minetest.env:get_objects_inside_radius(pos, 0.60)
		for c=1,table.getn(listeobj) do
			if not(listeobj[c]:is_player()) then
				listeobj[c]:remove()
			end
		end
	end,
})

--Bouton rotation

minetest.register_entity("mini_economique:rotation", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collisionbox = {-0.15,-0.15,-0.15, 0.15,0.15,0.15},
		visual = "upright_sprite",
		textures = {"economique_rotation.png"},
		visual_size = {x=0.30, y=0.30},
		is_visible = true,
	},
	poscube = {},
	set_item = function(self, itemstring)
		self.poscube = itemstring
	end,
	on_activate = function(self, staticdata)
		self.poscube = minetest.deserialize(staticdata)
		self.object:set_armor_groups({immortal=1})
	end,
	get_staticdata = function(self)
		return minetest.serialize(self.poscube)
	end,
	on_punch = function(self, hitter)
		self.object:remove()
	end,
	on_rightclick = function(self, clicker)
		local pos = self.poscube
		local mp = minetest.env:get_meta(pos):get_int("p")
		if mp < 4 then
			minetest.env:get_meta(pos):set_int("p",mp+1)
		else
			minetest.env:get_meta(pos):set_int("p",1)
		end
		affichage(pos)
	end,
})

--Bouton buy

minetest.register_entity("mini_economique:buy", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collisionbox = {-0.15,-0.15,-0.15, 0.15,0.15,0.15},
		visual = "upright_sprite",
		textures = {"economique_buy.png"},
		visual_size = {x=0.30, y=0.30},
		is_visible = true,
	},
	poscube = {},
	set_item = function(self, itemstring)
		self.poscube = itemstring
	end,
	on_activate = function(self, staticdata)
		self.poscube = minetest.deserialize(staticdata)
		self.object:set_armor_groups({immortal=1})
	end,
	get_staticdata = function(self)
		return minetest.serialize(self.poscube)
	end,
	on_punch = function(self, hitter)
		self.object:remove()
	end,
	on_rightclick = function(self, clicker)
		local pos = self.poscube
		local mitem1 = minetest.deserialize(minetest.env:get_meta(pos):get_string("item1"))
		local mitem2 = minetest.deserialize(minetest.env:get_meta(pos):get_string("item2"))
		if clicker:get_inventory():contains_item("main",mitem2) then
			clicker:get_inventory():remove_item("main", mitem2)
			clicker:get_inventory():add_item("main", mitem1)
		end
	end,
})


--Icone chiffre

for i=0,9 do
	minetest.register_entity("mini_economique:"..i.."", {
		initial_properties = {
			hp_max = 1,
			physical = false,
			collisionbox = {-0.15,-0.15,-0.15, 0.15,0.15,0.15},
			visual = "upright_sprite",
			textures = {"economique_"..i..".png"},
			visual_size = {x=0.30, y=0.30},
			is_visible = true,
		},
		on_activate = function(self, staticdata)
			self.object:set_armor_groups({immortal=1})
		end,
		on_punch = function(self, hitter)
			self.object:remove()
		end,
	})
end

--Hologramme

minetest.register_entity("mini_economique:item", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collisionbox = {-0.17,-0.17,-0.17, 0.17,0.17,0.17},
		visual = "sprite",
		visual_size = {x=0.15, y=0.15},
		textures = {""},
		spritediv = {x=1, y=1},
		initial_sprite_basepos = {x=0, y=0},
		is_visible = false,
	},
	itemname = "",
	set_item = function(self, itemstring)
		self.itemname = itemstring
		local itemname = itemstring
		local item_texture = nil
		local item_type = ""
		if minetest.registered_items[itemname] then
			item_texture = minetest.registered_items[itemname].inventory_image
			item_type = minetest.registered_items[itemname].type
		end
		prop = {
			is_visible = true,
			visual = "sprite",
			textures = {"unknown_item.png"}
		}
		if item_texture and item_texture ~= "" then
			prop.visual = "sprite"
			prop.textures = {item_texture}
			prop.visual_size = {x=0.15, y=0.15}
		else
			prop.visual = "wielditem"
			prop.textures = {itemname}
			prop.visual_size = {x=0.15, y=0.15}
			prop.automatic_rotate = math.pi * 0.25
		end
		self.object:set_properties(prop)
	end,
	on_activate = function(self, staticdata)
		self.itemname = staticdata
		self.object:set_armor_groups({immortal=1})
		self:set_item(self.itemname)
	end,
	get_staticdata = function(self)
		return self.itemname
	end,
	on_punch = function(self, hitter)
		self.object:remove()
	end,
})