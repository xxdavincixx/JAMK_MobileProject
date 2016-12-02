--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:dae4b605f37558fc991fbe4f53537d60:9810fe6248126c68b1e393fe31e859eb:34ef3cb91132e9ad2c74749b0d9fa54a$
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
            -- fps_jumper_0000_Vektor-Smartobjekt
            x=1,
            y=1,
            width=195,
            height=401,

            sourceX = 22,
            sourceY = 27,
            sourceWidth = 239,
            sourceHeight = 437
        },
        {
            -- fps_jumper_0001_Vektor-Smartobjekt
            x=1,
            y=404,
            width=195,
            height=389,

            sourceX = 22,
            sourceY = 38,
            sourceWidth = 239,
            sourceHeight = 437
        },
        {
            -- fps_jumper_0002_Vektor-Smartobjekt
            x=198,
            y=1,
            width=195,
            height=375,

            sourceX = 22,
            sourceY = 50,
            sourceWidth = 239,
            sourceHeight = 437
        },
        {
            -- fps_jumper_0003_Vektor-Smartobjekt
            x=198,
            y=378,
            width=195,
            height=365,

            sourceX = 21,
            sourceY = 60,
            sourceWidth = 239,
            sourceHeight = 437
        },
        {
            -- fps_jumper_0004_Vektor-Smartobjekt
            x=395,
            y=1,
            width=195,
            height=355,

            sourceX = 21,
            sourceY = 71,
            sourceWidth = 239,
            sourceHeight = 437
        },
        {
            -- fps_jumper_0005_Vektor-Smartobjekt
            x=592,
            y=1,
            width=195,
            height=347,

            sourceX = 21,
            sourceY = 81,
            sourceWidth = 239,
            sourceHeight = 437
        },
        {
            -- fps_jumper_0006_Vektor-Smartobjekt
            x=789,
            y=1,
            width=195,
            height=339,

            sourceX = 22,
            sourceY = 89,
            sourceWidth = 239,
            sourceHeight = 437
        },
        {
            -- fps_jumper_0007_Vektor-Smartobjekt
            x=789,
            y=342,
            width=195,
            height=327,

            sourceX = 22,
            sourceY = 101,
            sourceWidth = 239,
            sourceHeight = 437
        },
        {
            -- fps_jumper_0008_Vektor-Smartobjekt
            x=592,
            y=350,
            width=195,
            height=319,

            sourceX = 22,
            sourceY = 109,
            sourceWidth = 239,
            sourceHeight = 437
        },
        {
            -- fps_jumper_0009_Vektor-Smartobjekt
            x=395,
            y=358,
            width=195,
            height=311,

            sourceX = 22,
            sourceY = 117,
            sourceWidth = 239,
            sourceHeight = 437
        },
        {
            -- fps_jumper_0010_Vektor-Smartobjekt
            x=395,
            y=671,
            width=195,
            height=297,

            sourceX = 22,
            sourceY = 131,
            sourceWidth = 239,
            sourceHeight = 437
        },
        {
            -- fps_jumper_0011_Vektor-Smartobjekt
            x=592,
            y=671,
            width=195,
            height=287,

            sourceX = 23,
            sourceY = 141,
            sourceWidth = 239,
            sourceHeight = 437
        },
        {
            -- fps_jumper_0012_Vektor-Smartobjekt
            x=789,
            y=671,
            width=195,
            height=281,

            sourceX = 23,
            sourceY = 147,
            sourceWidth = 239,
            sourceHeight = 437
        },
    },
    
    sheetContentWidth = 985,
    sheetContentHeight = 969
}

SheetInfo.frameIndex =
{

    ["fps_jumper_0000_Vektor-Smartobjekt"] = 1,
    ["fps_jumper_0001_Vektor-Smartobjekt"] = 2,
    ["fps_jumper_0002_Vektor-Smartobjekt"] = 3,
    ["fps_jumper_0003_Vektor-Smartobjekt"] = 4,
    ["fps_jumper_0004_Vektor-Smartobjekt"] = 5,
    ["fps_jumper_0005_Vektor-Smartobjekt"] = 6,
    ["fps_jumper_0006_Vektor-Smartobjekt"] = 7,
    ["fps_jumper_0007_Vektor-Smartobjekt"] = 8,
    ["fps_jumper_0008_Vektor-Smartobjekt"] = 9,
    ["fps_jumper_0009_Vektor-Smartobjekt"] = 10,
    ["fps_jumper_0010_Vektor-Smartobjekt"] = 11,
    ["fps_jumper_0011_Vektor-Smartobjekt"] = 12,
    ["fps_jumper_0012_Vektor-Smartobjekt"] = 13,
}

SheetInfo.sequenceData =
{
    {name = "walk", start = 1, count = 13, time = 1150}
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
