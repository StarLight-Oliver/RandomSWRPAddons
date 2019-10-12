local animCommands = {
	["salute"] = "wos_clone_salute",
}

if SERVER then
	util.AddNetworkString("runGesture")

	for command, anim in pairs(animCommands) do
		concommand.Add(command, function(ply)
			local animID = ply:LookupSequence(anim)

			ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, animID, 0, true )
			ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, 1 )

			net.Start("runGesture")
				net.WriteEntity(ply)
				net.WriteString(anim)
			net.Broadcast()
		end)
	end
else
	net.Receive("runGesture", function()
		local ply = net.ReadEntity()
		if IsValid(ply) then
			local animID = ply:LookupSequence(net.ReadString())
			ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, animID, 0, true )
		end
	end)
end
