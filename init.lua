--[[
--Economique V0.6 par Jat
Licence GPLv2 or later for code
Licence CC-BY-SA for image

Echange des minerai de cuivre et d'argent en monnaie
Echange l'argent contre des minerai rare ou introuvable
Effaceur rajouter
Corrige un bug avec les piéces silver on pouvait acheter en cliquent sur n'importe quelle bloque
Ajout texture de Jat et Calinou pour les pieces
Ajout des deux bloque junglegrass et jungletree a la vente
Les prix sont calculer grace a la monnaie du personnage
Amelioration la zone marchand deploiement cube et simplification et aussi simplifaction des prix / Simplification pour la banque et ajout l'échange des piéces
--]]
--Variable utilisé
local a=0
--Monnaie
minetest.register_craftitem("economique:ps", {
	description = "Pièces de pierre",
	inventory_image = "economique_piecedepierre.png",
})

minetest.register_craftitem("economique:pc", {
	description = "Pièces de charbon",
	inventory_image = "economique_piecedecharbon.png",
})

minetest.register_craftitem("economique:pi", {
	description = "Pièces de fer",
	inventory_image = "economique_piecedefer.png",
})
--Cube pour banque

--Terminal
minetest.register_node("economique:banquea", {
	description = "Banque",
	tiles = {"economique_banquea.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
    groups = {unbreakable=1},
})

minetest.register_node("economique:banqueb", {
	description = "Banque",
	tiles = {"economique_banqueb.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
    groups = {unbreakable=1},
})

--Icone
minetest.register_node("economique:banque_icone_ironingot_pi", {
	description = "",
	tiles = {"economique_banque_icone_ironingot_pi.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
    groups = {unbreakable=1},
	drop = "",
})

minetest.register_node("economique:banque_icone_lumpcoal_pc", {
	description = "",
	tiles = {"economique_banque_icone_lumpcoal_pc.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
    groups = {unbreakable=1},
	drop = "",
})

minetest.register_node("economique:banque_icone_stone_ps", {
	description = "",
	tiles = {"economique_banque_icone_stone_ps.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
    groups = {unbreakable=1},
	drop = "",
})

--More ores

minetest.register_node("economique:banque_icone_lumpcopper_pc", {
	description = "",
	tiles = {"economique_banque_icone_lumpcopper_pc.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
    groups = {unbreakable=1},
	drop = "",
})
minetest.register_node("economique:banque_icone_lumptin_pc", {
	description = "",
	tiles = {"economique_banque_icone_lumptin_pc.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
    groups = {unbreakable=1},
	drop = "",
})
minetest.register_node("economique:banque_icone_lumpsilver_pc", {
	description = "",
	tiles = {"economique_banque_icone_lumpsilver_pc.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
    groups = {unbreakable=1},
	drop = "",
})
minetest.register_node("economique:banque_icone_lumpgold_pc", {
	description = "",
	tiles = {"economique_banque_icone_lumpgold_pc.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
    groups = {unbreakable=1},
	drop = "",
})
minetest.register_node("economique:banque_icone_lumpmithril_pc", {
	description = "",
	tiles = {"economique_banque_icone_lumpmithril_pc.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
    groups = {unbreakable=1},
	drop = "",
})

--Cube marchand

--Terminal
minetest.register_node("economique:marchanda", {
	description = "Marche",
	tiles = {"economique_marchanda.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
    groups = {unbreakable=1},
})
minetest.register_node("economique:marchandb", {
	description = "Marche",
	tiles = {"economique_marchandb.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
    groups = {unbreakable=1},
})


--Icone
--Pour changer les prix modifie le nombre seul il représente les ps mes les texture suiveront pas automatiquement.
local marchandlist={{"apple", 20, "default:apple 1"},
					{"cactus", 20, "default:cactus 1"},
					{"dirt", 1, "default:dirt 1"},
					{"gravel", 5, "default:gravel 1"},
					{"junglegrass", 1, "default:junglegrass 1"},
					{"jungletree", 10, "default:jungletree 1"},
					{"lumpclay", 50, "default:clay_lump 1"},
					{"mese", 5000, "default:mese 1"},
					{"mossycobble", 10, "default:mossycobble 1"},
					{"papyrus", 10, "default:papyrus 1"},
					{"sapling", 5, "default:sapling 1"},
					{"sand", 1, "default:sand 1"},
					{"torch", 150, "default:torch 1"},
					{"wood", 50, "default:wood 1"},
					{"ironingot",2100,"default:steel_ingot 1"},
					{"lumpcoal",300,"default:coal_lump 1"},
					{"stone",200,"default:stone 1"}
					}
for a=1,table.getn(marchandlist) do
	minetest.register_node("economique:marchand_icone_"..marchandlist[a][1].."", {
		description = "",
		tiles = {"economique_marchand_icone_"..marchandlist[a][1]..".png"},
		is_ground_content = false,
		walkable = true,
		pointable = true,
		groups = {unbreakable=1},
		drop = "",
	})
end

--Alias
minetest.register_alias("banque", "economique:banquea")
minetest.register_alias("marchand", "economique:marchanda")
--Function a modifier pour faire un mod
local function menu(marchand,p,node)
	local a=0
	local i=0
	for i = 1,table.getn(marchand)-1 do 
		for a = 1,table.getn(marchand[i]) do 
			if marchand[i][a]=="O" then
				if node.name==marchand[table.getn(marchand)][2] then
					minetest.env:add_node(p, {name=marchand[table.getn(marchand)][1]})
				else
					minetest.env:add_node(p, {name=marchand[table.getn(marchand)][2]})
				end
				p.x=p.x-a
				p.y=p.y+i
				break
			end
		end
	end
	for i = 1,table.getn(marchand)-1 do 
		for a = 1,table.getn(marchand[i]) do 
			if not(marchand[i][a]=="O") and not(marchand[i][a]=="") and node.name==marchand[table.getn(marchand)][2] then
				minetest.env:remove_node({x=p.x+a, y=p.y-i, z=p.z})
			elseif not(marchand[i][a]=="O") and not(marchand[i][a]=="") then
				minetest.env:add_node({x=p.x+a, y=p.y-i, z=p.z}, {name=""..marchand[i][a]..""})
			end
		end
	end
end

minetest.register_on_punchnode(function(p, node, player)

	--Partie Banque
	if node.name=="economique:banquea" or node.name=="economique:banqueb" then
		menu({{"economique:banque_icone_ironingot_pi","economique:banque_icone_lumpmithril_pc","economique:banque_icone_lumpsilver_pc"},
		{"economique:banque_icone_lumpcoal_pc","economique:banque_icone_lumpgold_pc","economique:banque_icone_lumptin_pc"},
		{"economique:banque_icone_stone_ps","O","economique:banque_icone_lumpcopper_pc"},
		{"economique:banquea","economique:banqueb"}},p,node)
	elseif node.name=="economique:banque_icone_lumpcoal_pc" or node.name=="economique:banque_icone_stone_ps" or node.name=="economique:banque_icone_ironingot_pi" or node.name=="economique:banque_icone_lumptin_pc" or node.name=="economique:banque_icone_lumpcopper_pc" or node.name=="economique:banque_icone_lumpsilver_pc" or node.name=="economique:banque_icone_lumpgold_pc" or node.name=="economique:banque_icone_lumpmithril_pc" then
		--{cube frappe , prit, donné}
		local element={{"economique:banque_icone_lumpcoal_pc","default:coal_lump 1","economique:pc 2"},
		{"economique:banque_icone_stone_ps","default:stone 1","economique:ps 10"},
		{"economique:banque_icone_ironingot_pi","default:steel_ingot 1","economique:pc 20"},
		{"economique:banque_icone_lumptin_pc","moreores:tin_lump 1","economique:pc 5"},
		{"economique:banque_icone_lumpcopper_pc","moreores:copper_lump 1","economique:pc 5"},
		{"economique:banque_icone_lumpsilver_pc","moreores:silver_lump 1","economique:pc 15"},
		{"economique:banque_icone_lumpgold_pc","moreores:gold_lump 1","economique:pc 20"},
		{"economique:banque_icone_lumpmithril_pc","moreores:mithril_lump 1","economique:pc 25"}	
		}
		local i=0
		for i = 1,table.getn(element) do 
			if node.name==element[i][1] and player:get_inventory():contains_item('main', element[i][2]) then
				player:get_inventory():add_item('main', element[i][3])
				player:get_inventory():remove_item('main', element[i][2])
				break
			end
		end

	--Partie Marchand
		--Menu
	elseif node.name=="economique:marchanda" or node.name=="economique:marchandb" then
		--Toujour prendre la plus grand largeur pour chaque ligne (sauf la dernier ) et le "O" est le cube d'origine et la dernier ligne le cube "on" "off"
		menu({{"economique:marchand_icone_"..marchandlist[1][1].."","","","","","","economique:marchand_icone_"..marchandlist[2][1]..""},
			{"economique:marchand_icone_"..marchandlist[3][1].."","","","economique:marchand_icone_"..marchandlist[17][1].."","","","economique:marchand_icone_"..marchandlist[4][1]..""},
			{"economique:marchand_icone_"..marchandlist[5][1].."","economique:marchand_icone_"..marchandlist[6][1].."","economique:marchand_icone_"..marchandlist[15][1].."","","economique:marchand_icone_"..marchandlist[16][1].."","economique:marchand_icone_"..marchandlist[7][1].."","economique:marchand_icone_"..marchandlist[8][1]..""},
			{"economique:marchand_icone_"..marchandlist[9][1].."","economique:marchand_icone_"..marchandlist[10][1].."","economique:marchand_icone_"..marchandlist[11][1].."","O","economique:marchand_icone_"..marchandlist[12][1].."","economique:marchand_icone_"..marchandlist[13][1].."","economique:marchand_icone_"..marchandlist[14][1]..""},
			{"economique:marchanda","economique:marchandb"}},p,node)
	end	

	--Partie prix
	for a=1,table.getn(marchandlist) do
		if node.name=="economique:marchand_icone_"..marchandlist[a][1].."" then
			local function prix(argent,cuivre,somme)
				-- 1 =argent / 2 = cuivre /3 = retenue
				local resta={}
				table.insert(resta, 1, 0)
				table.insert(resta, 2, 0)
				table.insert(resta, 3, 0)
				if argent>=math.ceil(somme/100) then
					resta[1]=math.floor(somme/100)
					if cuivre>=somme-resta[1]*100 then
						resta[2]=somme-(resta[1]*100)
					else
						resta[1]=resta[1]+1
						resta[3]=(resta[1]*100)-somme
					end
				elseif cuivre>=somme then
					resta[2]=somme
				elseif argent<math.ceil(somme/100) then
					resta[1]=argent
					resta[2]=somme-(argent*100)
				end
				return resta
			end
			
			
			
			local ps=0
			local pc=0
			local pi=0
			local rest={}
			local i=0
			for i = 1,player:get_inventory():get_size('main') do 
				local element=player:get_inventory():get_stack("main",i):get_name()
				if not(element=="") then
				local nombres=player:get_inventory():get_stack("main",i):get_count()
					if "economique:ps"==element then
						ps=ps+nombres
					elseif "economique:pc"==element then
						pc=pc+nombres
					elseif "economique:pi"==element then
						pi=pi+nombres
					end
				end
			end
			--Les element
			for i = 1,table.getn(marchandlist) do 
				if node.name=="economique:marchand_icone_"..marchandlist[i][1].."" and pi*2000+pc*100+ps>=marchandlist[i][2] then
					player:get_inventory():add_item('main', marchandlist[i][3])
					rest=prix(pc,ps,marchandlist[i][2])
					break
				end
			end
			--/Les element
			if table.getn(rest)==3 then
				player:get_inventory():remove_item('main', 'economique:pc '..rest[1]..'')
				player:get_inventory():remove_item('main', 'economique:ps '..rest[2]..'')
				player:get_inventory():add_item('main', 'economique:ps '..rest[3]..'')
			end
			break
		end
	end
end)