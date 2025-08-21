XBOX = nil			-- typy maja funkcje dostepne przez meta,
XBOX_lev2 = nil	        -- niektore dane w klasach nie sa kopiowane, gdy nie sa potrzebne (inne utils i inne klasy -
						-- s_SubClassParams) i __funcs inaczej zapamietywane (pliki .xbox)
							
EditorFiles = true

if IsFinalBuild() or XBOX then
	EditorFiles = nil
end

--================================================================
-- CHEAT STUFF
--================================================================
local test1 = false
local test2 = false
local test3 = false
if test1 then
-- TEST FOR LOADER.LUA 
    local testfile = nil
    local extractedlscripts = true
    testfile = io.open ("../Data/LScripts/Loader.lua","r")
    if not testfile then
    	extractedlscripts = false
    else
    	io.close(testfile)
    end
    if extractedlscripts then
    	MsgBox("FILE: Data\\Lscripts\\loader.lua present, please remove this file. PK will now quit.")
    	Exit(1)
    end
end
if test2 then
-- DIRTY CHECK TO SEE IF A LOADER HAS ALREADY RUN    
    if path then
    	MsgBox("Corrupt LScripts:1. PK will now quit.")
    	Exit(1)
    end
end   
path = "../Data/LScripts/"
if test3 then  
-- CHECK FILE SIZE?  

local checkfiles = {
        ["Loader.lua"]                              = 8532,
        ["Main/Game.lua"]                           = 83130,
        ["Main/GameMP.lua"]                         = 94113,
        ["Main/Bot.lua"]                            = 33267,
        ["Main/Utils.lua"]                          = 37512,
        ["Classes/CPlayer.lua"]                     = 83744,
        ["Classes/CItem.lua"]                       = 38601,
        ["HUD/HUD.lua"]                             = 66683,
        ["HUD/HUD2.lua"]                            = 28191,
        ["HUD/HUD3.lua"]                            = 18603,
        ["HUD/Console.lua"]                         = 81902,
        ["HUD/Console2.lua"]                        = 72835,
        -- WEAPONS
        ["Templates/Weapons/DriverElectro.lua"]     = 29155,
        ["Templates/Weapons/MiniGunRL.lua"]         = 19757,
        ["Templates/Weapons/Shotgun.lua"]           = 18023,
        ["Templates/Weapons/StakeGunGL.lua"]        = 12395,
}

for file, size in pairs(checkfiles) do
        if FS.File_GetSize(path..file) ~= size then
                MsgBox("Corrupt LScripts:"..file.." "..size..". PK will now quit.")
                Exit(1)
        end
end

checkfiles = nil
end
--================================================================
 
FS.RegisterPack("../Data/".."PKPlusData.pak","../Data/PKPlusData/")
FS.RegisterPack("../Data/".."Locs.pak","../Data/Locs/")
FS.RegisterPack("../Data/".."Mapview.pak","../Data/Mapview/")
FS.RegisterPack("../Data/".."Waypoints.pak","../Data/Waypoints/")
FS.RegisterPack("../Data/".."Hitsounds.pak","../Data/Hitsounds/")

linker = "versionB.txt ../Data/Hitsounds ../Data/Locs Hitsounds.pak"

-- Create default external files
FS.CreateDirectory('../Data/Hitsounds')
FS.ExtractPack('../Data/Hitsounds.pak','../Data/Hitsounds')

local function ensurePackExtracted(dir, versionFile, pak)
        local base = '../Data/'..dir
        if FS.File_Exist(base..'/'..versionFile) then return end
        FS.CreateDirectory(base)
        FS.ExtractPack('../Data/'..pak, base)
end

ensurePackExtracted('Locs', 'versionB.txt', 'Locs.pak')
ensurePackExtracted('Mapview', 'versionA.txt', 'Mapview.pak')
ensurePackExtracted('Waypoints', 'versionB.txt', 'Waypoints.pak')

--collectgarbage(0)
--Log("START LOADER.LUA : "..GetGCCount())


------------------------------------------------------------------------------
DoFile(path.."Main/Utils.lua")
if XBOX_lev2 then
	DoFile(path.."Main/Utils.xbox")
end

DoFile(path.."Main/Cfg.lua")
DoFile(path.."Main/Loc.lua")
DoFile(path.."Main/Waypoint.lua")
DoFile(path.."Main/Logfile.lua")
DoFile(path.."Main/Mapview.lua")
DoFile(path.."Main/Tweak.lua")
DoFile(path.."Main/Definitions.lua")
DoFile(path.."Main/Network.lua")
DoFile(path.."Main/Profiler.lua")
DoFile(path.."Main/eliza.lua")
------------------------------------------------------------------------------
if XBOX then
	DoFile(path.."Classes/TypesXBOX/Vector.lua")
	DoFile(path.."Classes/TypesXBOX/VectorA.lua")
	DoFile(path.."Classes/TypesXBOX/Quaternion.lua")
	DoFile(path.."Classes/TypesXBOX/Color.lua")
	DoFile(path.."Classes/TypesXBOX/Collection.lua")
else
	DoFile(path.."Classes/Types/Vector.lua")
	DoFile(path.."Classes/Types/VectorA.lua")
	DoFile(path.."Classes/Types/Quaternion.lua")
	DoFile(path.."Classes/Types/Color.lua")
	DoFile(path.."Classes/Types/Collection.lua")
end

ToLoadClasses = {
		"CObject",
		"CItem",
		"CActor",
		"CPlayer",
		"CProcess",
		"CLevel",
		"CLight",
		"CBillboard",
		"CSound",
		"CArea",
		"CBox",
		"CWeapon",
		"CAcousticEnv",
		"CMusicEnv",
		"CAction",
		"CSpawnPoint",
		"CParticleFX",
		"CEnvironment",
	}
for _, v in ipairs(ToLoadClasses) do
        DoFile(path.."Classes/"..v..".lua")
        if EditorFiles then
                DoFile(path.."Classes/"..v..".editor", false)
        end
        if XBOX_lev2 then
                DoFile(path.."Classes/"..v..".xbox", false)
        end
end

for _, v in ipairs(ToLoadClasses) do
    Inherit(getfenv()[v],CObject)
end

ToLoadClasses = nil

------------------------------------------------------------------------------
DoFile(path.."Classes/Ai/CAiBrain.lua")
DoFile(path.."Classes/Entities/EMesh.lua")
DoFile(path.."Classes/Entities/EVolumetric.lua")
------------------------------------------------------------------------------
--DoFile(path.."Processes/PFadeInOutLight.lua")
--DoFile(path.."Processes/PBindToJoint.lua")
--DoFile(path.."Processes/PMusicFade.lua")
--DoFile(path.."Templates/Processes/TWait.CProcess")
--DoFile(path.."Processes/PBindJointToJoint.lua")
--DoFile(path.."Processes/PCameraControler.lua")
--DoFile(path.."Processes/PBenchmarkControler.lua")
--DoFile(path.."Processes/PBulletTimeControler.lua")
--DoFile(path.."Processes/PMove.lua")
--DoFile(path.."Processes/PBurningItem.lua")
--DoFile(path.."Processes/PPlayerAnimation.lua")		-- zmienic w gameMP
--DoFile(path.."Processes/PSpectatorControler.lua")	-- zmienic w gameMP
------------------------------------------------------------------------------
DoFile(path.."Main/GObjects.lua")
DoFile(path.."Main/Game.lua")
DoFile(path.."Main/GameMP.lua")
DoFile(path.."Main/GameMPComms.lua")
DoFile(path.."Main/GameMPUtils.lua")
DoFile(path.."Main/GameMPStats.lua")
DoFile(path.."Main/Languages.lua")
DoFile(path.."Main/SaveGame.lua")
DoFile(path.."Main/Cache.lua")
--DoFile(path.."Main/MD5.lua")
DoFile(path.."Main/PiTaBOT.lua")
------------------------------------------------------------------------------
DoFile(path.."HUD/Scoreboard.lua")
DoFile(path.."HUD/HUD.lua")
DoFile(path.."HUD/HUD2.lua")
DoFile(path.."HUD/HUD3.lua")
DoFile(path.."HUD/Levels.lua")
if not XBOX_lev2 then
	DoFile(path.."HUD/PainMenu.lua")
end
DoFile(path.."HUD/MagicBoard.lua")
DoFile(path.."HUD/Console.lua")
DoFile(path.."HUD/Console2.lua")
------------------------------------------------------------------------------
DoFile(path.."Main/Bot.lua")
------------------------------------------------------------------------------
if EditorFiles then
	DoFile(path.."Editor/EWayPoints.lua")
	DoFile(path.."Editor/EFloors.lua")
end
DoFile(path.."Editor/Editor.lua")
--DoFile(path.."Templates/Templates.lua")
------------------------------------------------------------------------------
--MsgBox("Loader - koniec")
if loadfile(path.."local.lua") then
	dofile(path.."local.lua")
end


--collectgarbage(0)
--Log("END LOADER.LUA : "..GetGCCount())
