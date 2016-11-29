--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:c3a9ce648a5d59db3c31c066907a64f6:dc1487ff0495dd30da3a50c85d756d74:31febdb2e2caae153cb1a03d5e13144a$
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
            -- walker_animation_0000_Vektor-Smartobjekt
            x=1639,
            y=1,
            width=271,
            height=630,

            sourceX = 33,
            sourceY = 27,
            sourceWidth = 337,
            sourceHeight = 684
        },
        {
            -- walker_animation_0001_Vektor-Smartobjekt
            x=1093,
            y=1,
            width=271,
            height=632,

            sourceX = 33,
            sourceY = 25,
            sourceWidth = 337,
            sourceHeight = 684
        },
        {
            -- walker_animation_0002_Vektor-Smartobjekt
            x=820,
            y=1,
            width=271,
            height=634,

            sourceX = 33,
            sourceY = 26,
            sourceWidth = 337,
            sourceHeight = 684
        },
        {
            -- walker_animation_0003_Vektor-Smartobjekt
            x=1366,
            y=1,
            width=271,
            height=632,

            sourceX = 33,
            sourceY = 27,
            sourceWidth = 337,
            sourceHeight = 684
        },
        {
            -- walker_animation_0004_Vektor-Smartobjekt
            x=547,
            y=1,
            width=271,
            height=638,

            sourceX = 33,
            sourceY = 23,
            sourceWidth = 337,
            sourceHeight = 684
        },
        {
            -- walker_animation_0005_Vektor-Smartobjekt
            x=274,
            y=1,
            width=271,
            height=640,

            sourceX = 33,
            sourceY = 22,
            sourceWidth = 337,
            sourceHeight = 684
        },
        {
            -- walker_animation_0006_Vektor-Smartobjekt
            x=1,
            y=1,
            width=271,
            height=646,

            sourceX = 33,
            sourceY = 18,
            sourceWidth = 337,
            sourceHeight = 684
        },
    },
    
    sheetContentWidth = 1911,
    sheetContentHeight = 648
}

SheetInfo.frameIndex =
{

    ["walker_animation_0000_Vektor-Smartobjekt"] = 1,
    ["walker_animation_0001_Vektor-Smartobjekt"] = 2,
    ["walker_animation_0002_Vektor-Smartobjekt"] = 3,
    ["walker_animation_0003_Vektor-Smartobjekt"] = 4,
    ["walker_animation_0004_Vektor-Smartobjekt"] = 5,
    ["walker_animation_0005_Vektor-Smartobjekt"] = 6,
    ["walker_animation_0006_Vektor-Smartobjekt"] = 7,
}

SheetInfo.sequenceData =
{
    {name = "walk", start = 1, count = 7, time = 350}
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
