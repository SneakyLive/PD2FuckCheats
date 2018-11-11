Hooks:PostHook(NetworkPeer, "ip_trust", "fuck_cheats", function(self, state)

local NOSALOBBY_is_server_ok = NetworkMatchMakingSTEAM.is_server_ok
function NetworkMatchMakingSTEAM:is_server_ok(friends_only, room, attributes_list, ...)
	if attributes_list.numbers[11] ~= "value_pending" then
		return false
	end
	return NOSALOBBY_is_server_ok(self, friends_only, room, attributes_list, ...)
end

local NOSALOBBY_lobby_to_numbers = NetworkMatchMakingSTEAM._lobby_to_numbers
function NetworkMatchMakingSTEAM._lobby_to_numbers(self, lobby, ...)
	local numbers = NOSALOBBY_lobby_to_numbers(self, lobby, ...)
	table.insert(numbers, lobby:key_value("silent_assassin"))
	return numbers
end

	if not Network:is_server() then
		return
	end

	DelayedCalls:Add( "fuck_cheats_caller", 2, function()
		local user = Steam:user(self:ip())
		if user and user:rich_presence("modded") == "1" or self:modded() then
			for i, mod in ipairs(self:synced_mods()) do
				local mod_mini = string.lower(mod.name)	
				local kick_on = {}
				local questionable = {}
				local suspicious = nil

				kick_on = {
					"pirate perfection",
					"p3dhack",
					"p3dhack free",
					"dlc unlocker",
					"skin unlocker",
					"p3dunlocker",
					"arsium's weapons rebalance recoil",
					"overkill mod",
					"silent assassin",
					"carry stacker",
					"selective dlc unlocker",
					"the great skin unlock",
					"beyond cheats"
				}

				for _, v in pairs(kick_on) do
					if mod_mini == v then
						local identifier = "cheater_banned_" .. tostring(self:id())
						managers.ban_list:ban(identifier, self:name())
						managers.chat:feed_system_message(1, self:name() .. " wurde aufgrund Verwendung folgender Modifikation gebannt: " .. mod.name)
						local message_id = 0
						message_id = 6
						managers.network:session():send_to_peers("kick_peer", self:id(), message_id)
						managers.network:session():on_peer_kicked(self, self:id(), message_id)
						return
					end
				end

				questionable = {
					"pirate",
					"p3d",
					"hack",
					"cheat",
					"invisible",
					"dmg",
					"damage",
					"unlocker",
					"unlock",
					"dlc",
					"trainer",
					"sa",
					"skill",
					"carry stacker",
					"god",
					"x-ray",
					"mvp"
				}

				for k, pc in pairs(questionable) do
					if string.find(mod_mini, pc) then
						log("Verdächtiger Spieler festgestellt!")
						managers.chat:feed_system_message(1, self:name() .. " verwendet eine verdächtige Modifikation: " .. mod.name)
						suspicious = 1
					end
				end
			end

			if suspicious then
				managers.chat:feed_system_message(1, self:name() .. " wurde verwarnt!")
			else
				managers.chat:feed_system_message(1, self:name() .. " verwendet keine verdächtige Modifikation.")
			end
	end)
end)