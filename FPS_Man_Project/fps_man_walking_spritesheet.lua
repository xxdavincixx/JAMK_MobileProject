--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:1be26c3759c54ca227e943a7691b4c3a:e3bcb0e8cda477200a927ab68432b218:bbb987bfc735fb7aac2b0678ff58fd9b$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "fps_man_walking_spritesheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- FPS_man_walking__0000_Vektor-Smartobjekt
            x=505,
            y=1,
            width=74,
            height=240,

            sourceX = 37,
            sourceY = 30,
            sourceWidth = 152,
            sourceHeight = 300
        },
        {
            -- FPS_man_walking__0001_Vektor-Smartobjekt
            x=337,
            y=1,
            width=82,
            height=240,

            sourceX = 37,
            sourceY = 31,
            sourceWidth = 152,
            sourceHeight = 300
        },
        {
            -- FPS_man_walking__0002_Vektor-Smartobjekt
            x=421,
            y=1,
            width=82,
            height=240,

            sourceX = 36,
            sourceY = 30,
            sourceWidth = 152,
            sourceHeight = 300
        },
        {
            -- FPS_man_walking__0003_Vektor-Smartobjekt
            x=1019,
            y=1,
            width=94,
            height=234,

            sourceX = 32,
            sourceY = 32,
            sourceWidth = 152,
            sourceHeight = 300
        },
        {
            -- FPS_man_walking__0004_Vektor-Smartobjekt
            x=657,
            y=1,
            width=84,
            height=236,

            sourceX = 37,
            sourceY = 32,
            sourceWidth = 152,
            sourceHeight = 300
        },
        {
            -- FPS_man_walking__0005_Vektor-Smartobjekt
            x=827,
            y=1,
            width=74,
            height=236,

            sourceX = 38,
            sourceY = 31,
            sourceWidth = 152,
            sourceHeight = 300
        },
        {
            -- FPS_man_walking__0006_Vektor-Smartobjekt
            x=581,
            y=1,
            width=74,
            height=238,

            sourceX = 36,
            sourceY = 31,
            sourceWidth = 152,
            sourceHeight = 300
        },
        {
            -- FPS_man_walking__0007_Vektor-Smartobjekt
            x=743,
            y=1,
            width=82,
            height=236,

            sourceX = 33,
            sourceY = 31,
            sourceWidth = 152,
            sourceHeight = 300
        },
        {
            -- FPS_man_walking__0008_Vektor-Smartobjekt
            x=239,
            y=1,
            width=96,
            height=240,

            sourceX = 29,
            sourceY = 29,
            sourceWidth = 152,
            sourceHeight = 300
        },
        {
            -- FPS_man_walking__0009_Vektor-Smartobjekt
            x=1,
            y=1,
            width=84,
            height=242,

            sourceX = 33,
            sourceY = 29,
            sourceWidth = 152,
            sourceHeight = 300
        },
        {
            -- FPS_man_walking__0010_Vektor-Smartobjekt
            x=87,
            y=1,
            width=74,
            height=242,

            sourceX = 39,
            sourceY = 29,
            sourceWidth = 152,
            sourceHeight = 300
        },
        {
            -- FPS_man_walking__0011_Vektor-Smartobjekt
            x=163,
            y=1,
            width=74,
            height=242,

            sourceX = 38,
            sourceY = 28,
            sourceWidth = 152,
            sourceHeight = 300
        },
        {
            -- FPS_man_walking__0012_Vektor-Smartobjekt
            x=903,
            y=1,
            width=114,
            height=234,

            sourceX = 20,
            sourceY = 29,
            sourceWidth = 152,
            sourceHeight = 300
        },
    },
    
    sheetContentWidth = 1114,
    sheetContentHeight = 244
}

SheetInfo.frameIndex =
{

    ["FPS_man_walking__0000_Vektor-Smartobjekt"] = 1,
    ["FPS_man_walking__0001_Vektor-Smartobjekt"] = 2,
    ["FPS_man_walking__0002_Vektor-Smartobjekt"] = 3,
    ["FPS_man_walking__0003_Vektor-Smartobjekt"] = 4,
    ["FPS_man_walking__0004_Vektor-Smartobjekt"] = 5,
    ["FPS_man_walking__0005_Vektor-Smartobjekt"] = 6,
    ["FPS_man_walking__0006_Vektor-Smartobjekt"] = 7,
    ["FPS_man_walking__0007_Vektor-Smartobjekt"] = 8,
    ["FPS_man_walking__0008_Vektor-Smartobjekt"] = 9,
    ["FPS_man_walking__0009_Vektor-Smartobjekt"] = 10,
    ["FPS_man_walking__0010_Vektor-Smartobjekt"] = 11,
    ["FPS_man_walking__0011_Vektor-Smartobjekt"] = 12,
    ["FPS_man_walking__0012_Vektor-Smartobjekt"] = 13,
}

SheetInfo.sequenceData =
{
	{name = "idle", start = 12, count = 1, time = 1000},
    {name = "walk", frames = {10,9,8,7,6,5,4,3,2,1}, time = 1000},
    {name = "jump", start = 13, count = 1, time = 1000}
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

function SheetInfo:getSequenceData()
	return self.sequenceData;
end

return SheetInfo
