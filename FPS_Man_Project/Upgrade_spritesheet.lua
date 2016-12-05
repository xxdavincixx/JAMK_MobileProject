--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:09f1aff8eab9279ad36864ff6c8633cd:8999bf2687d391da352d6257ade2c588:89337555d5f18be041aeb15429cef0e1$
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
            -- Upgrade_0000_Vektor-Smartobjekt
            x=553,
            y=1,
            width=260,
            height=253,

            sourceX = 59,
            sourceY = 71,
            sourceWidth = 380,
            sourceHeight = 397
        },
        {
            -- Upgrade_0001_Vektor-Smartobjekt
            x=271,
            y=537,
            width=260,
            height=257,

            sourceX = 60,
            sourceY = 69,
            sourceWidth = 380,
            sourceHeight = 397
        },
        {
            -- Upgrade_0002_Vektor-Smartobjekt
            x=283,
            y=1,
            width=268,
            height=261,

            sourceX = 55,
            sourceY = 67,
            sourceWidth = 380,
            sourceHeight = 397
        },
        {
            -- Upgrade_0003_Vektor-Smartobjekt
            x=1,
            y=272,
            width=274,
            height=263,

            sourceX = 52,
            sourceY = 67,
            sourceWidth = 380,
            sourceHeight = 397
        },
        {
            -- Upgrade_0004_Vektor-Smartobjekt
            x=1,
            y=1,
            width=280,
            height=269,

            sourceX = 50,
            sourceY = 63,
            sourceWidth = 380,
            sourceHeight = 397
        },
        {
            -- Upgrade_0005_Vektor-Smartobjekt
            x=277,
            y=272,
            width=274,
            height=263,

            sourceX = 52,
            sourceY = 67,
            sourceWidth = 380,
            sourceHeight = 397
        },
        {
            -- Upgrade_0006_Vektor-Smartobjekt
            x=1,
            y=537,
            width=268,
            height=261,

            sourceX = 55,
            sourceY = 67,
            sourceWidth = 380,
            sourceHeight = 397
        },
        {
            -- Upgrade_0007_Vektor-Smartobjekt
            x=533,
            y=537,
            width=260,
            height=257,

            sourceX = 60,
            sourceY = 69,
            sourceWidth = 380,
            sourceHeight = 397
        },
        {
            -- Upgrade_0008_Vektor-Smartobjekt
            x=553,
            y=256,
            width=260,
            height=253,

            sourceX = 59,
            sourceY = 71,
            sourceWidth = 380,
            sourceHeight = 397
        },
    },
    
    sheetContentWidth = 814,
    sheetContentHeight = 799
}

SheetInfo.frameIndex =
{

    ["Upgrade_0000_Vektor-Smartobjekt"] = 1,
    ["Upgrade_0001_Vektor-Smartobjekt"] = 2,
    ["Upgrade_0002_Vektor-Smartobjekt"] = 3,
    ["Upgrade_0003_Vektor-Smartobjekt"] = 4,
    ["Upgrade_0004_Vektor-Smartobjekt"] = 5,
    ["Upgrade_0005_Vektor-Smartobjekt"] = 6,
    ["Upgrade_0006_Vektor-Smartobjekt"] = 7,
    ["Upgrade_0007_Vektor-Smartobjekt"] = 8,
    ["Upgrade_0008_Vektor-Smartobjekt"] = 9,
}

SheetInfo.sequenceData =
{
    {name = "animate", start = 1, count = 9, time = 420}
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
