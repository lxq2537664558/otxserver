BlessingsDialog = {
	Developer = "Charles (Cjaker)",
	Version = "1.0",
	LastUpdate = "14/07/2017 - 8:47 (PM)",
	Missing = {
		"Insert & Select query in blessings_history",
		"Gamestore buy blessing",
		"Correct percents in blessings dialog"
	},
}

function onRecvbyte(player, msg, byte)
	if (byte == 207) then
		if (player:getClient().os ~= CLIENTOS_NEW_WINDOWS or player:getClient().os ~= CLIENTOS_FLASH) then
			player:sendCancelMessage("Only work with Flash Client & 11.0")
			return false
		end

		sendBlessingsDialog(player)
	end
end

function sendBlessingsDialog(player)
	local msg = NetworkMessage()
	msg:addByte(155)
	msg:addByte(8) -- total blessings
	local c, bless = 1, 2
	while (c < 9) do
		msg:addU16(bless) -- bless type
		if (player:hasBlessing(c)) then
			msg:addByte(player:getBlessingCount(c)) -- amount of unique bless
		else
			msg:addByte(0)
		end
		c = c + 1
		bless = bless * 2
	end

	msg:addByte(2) -- BYTE PREMIUM (only work with premium days)
	msg:addByte(100) -- XP Loss Lower
	msg:addByte(100) -- XP/Skill loss min pvp death
	msg:addByte(100) -- XP/Skill loss max pvp death
	msg:addByte(100) -- XP/Skill pve death
	msg:addByte(100) -- Equip container lose pvp death
	msg:addByte(100) -- Equip container pve death

	local haveSkull = player:getSkull() >= 4
	if (haveSkull) then
		msg:addByte(1) -- is red/black skull
		local playerAmulet = player:getSlotItem(CONST_SLOT_AMULET)
		if (playerAmulet and playerAmulet:getId() == 2173) then
			msg:addByte(1)
		else
			msg:addByte(0)
		end
	else
		msg:addByte(0)
		msg:addByte(0)
	end

	-- History
	local historyAmount = 1
	msg:addByte(historyAmount) -- History log count
	for i = 1, historyAmount do
		msg:addU32(1500060480) -- timestamp
		msg:addByte(0) -- Color message (1 - Red | 0 = White loss)
		msg:addString("Que delicia de bless cara...") -- History message
	end

	msg:sendToPlayer(player)
end
