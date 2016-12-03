--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:6827149fc219de99710a8688919a0cda:a2f352d11e0628dde1380624c255623a:7cc9c6f98ab8f96f8ddfc7319170d1e8$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- fps_hopper_animation_0000_Vektor-Smartobjekt
            x=611,
            y=1303,
            width=323,
            height=615,

            sourceX = 6,
            sourceY = 177,
            sourceWidth = 417,
            sourceHeight = 813
        },
        {
            -- fps_hopper_animation_0001_Vektor-Smartobjekt
            x=611,
            y=664,
            width=313,
            height=637,

            sourceX = 21,
            sourceY = 153,
            sourceWidth = 417,
            sourceHeight = 813
        },
        {
            -- fps_hopper_animation_0002_Vektor-Smartobjekt
            x=603,
            y=1,
            width=315,
            height=661,

            sourceX = 20,
            sourceY = 130,
            sourceWidth = 417,
            sourceHeight = 813
        },
        {
            -- fps_hopper_animation_0003_Vektor-Smartobjekt
            x=302,
            y=774,
            width=307,
            height=685,

            sourceX = 30,
            sourceY = 106,
            sourceWidth = 417,
            sourceHeight = 813
        },
        {
            -- fps_hopper_animation_0004_Vektor-Smartobjekt
            x=306,
            y=1,
            width=295,
            height=711,

            sourceX = 41,
            sourceY = 80,
            sourceWidth = 417,
            sourceHeight = 813
        },
        {
            -- fps_hopper_animation_0005_Vektor-Smartobjekt
            x=1,
            y=774,
            width=299,
            height=739,

            sourceX = 51,
            sourceY = 52,
            sourceWidth = 417,
            sourceHeight = 813
        },
        {
            -- fps_hopper_animation_0006_Vektor-Smartobjekt
            x=1,
            y=1,
            width=303,
            height=771,

            sourceX = 56,
            sourceY = 21,
            sourceWidth = 417,
            sourceHeight = 813
        },
    },
    
    sheetContentWidth = 935,
    sheetContentHeight = 1919
}

SheetInfo.frameIndex =
{

    ["fps_hopper_animation_0000_Vektor-Smartobjekt"] = 1,
    ["fps_hopper_animation_0001_Vektor-Smartobjekt"] = 2,
    ["fps_hopper_animation_0002_Vektor-Smartobjekt"] = 3,
    ["fps_hopper_animation_0003_Vektor-Smartobjekt"] = 4,
    ["fps_hopper_animation_0004_Vektor-Smartobjekt"] = 5,
    ["fps_hopper_animation_0005_Vektor-Smartobjekt"] = 6,
    ["fps_hopper_animation_0006_Vektor-Smartobjekt"] = 7,
}

SheetInfo.sequenceData =
{
    {name = "walk", start = 1, count = 7, time = 420}
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
