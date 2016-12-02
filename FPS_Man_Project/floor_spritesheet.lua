--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:189ee9f06998fe5c52ab66f18efd3b1f:8b51a2285263df7d53205c20367d9ea0:1a6d30d27751cd0e368eac4bd87ee70e$
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
            -- Floor_0000_Vektor-Smartobjekt
            x=1,
            y=1,
            width=159,
            height=159,

        },
        {
            -- Floor_0001_Vektor-Smartobjekt
            x=162,
            y=1,
            width=159,
            height=159,

        },
        {
            -- Floor_0002_Vektor-Smartobjekt
            x=323,
            y=1,
            width=159,
            height=159,

        },
        {
            -- Floor_0003_Vektor-Smartobjekt
            x=1,
            y=162,
            width=159,
            height=159,

        },
        {
            -- Floor_0004_Vektor-Smartobjekt
            x=162,
            y=162,
            width=159,
            height=159,

        },
        {
            -- Floor_0005_Vektor-Smartobjekt
            x=323,
            y=162,
            width=159,
            height=159,

        },
        {
            -- Floor_0006_Vektor-Smartobjekt
            x=1,
            y=323,
            width=159,
            height=159,

        },
        {
            -- Floor_0007_Vektor-Smartobjekt
            x=162,
            y=323,
            width=159,
            height=159,

        },
        {
            -- Floor_0008_Vektor-Smartobjekt
            x=323,
            y=323,
            width=159,
            height=159,

        },
        {
            -- Floor_0009_Vektor-Smartobjekt
            x=1,
            y=484,
            width=159,
            height=159,

        },
        {
            -- Floor_0010_Vektor-Smartobjekt
            x=162,
            y=484,
            width=159,
            height=159,

        },
        {
            -- Floor_0011_Vektor-Smartobjekt
            x=323,
            y=484,
            width=159,
            height=159,

        },
        {
            -- Floor_0012_Vektor-Smartobjekt
            x=1,
            y=645,
            width=159,
            height=159,

        },
        {
            -- platform
            x=1,
            y=806,
            width=352,
            height=34,

        },
    },
    
    sheetContentWidth = 483,
    sheetContentHeight = 841
}

SheetInfo.frameIndex =
{

    ["Floor_0000_Vektor-Smartobjekt"] = 1,
    ["Floor_0001_Vektor-Smartobjekt"] = 2,
    ["Floor_0002_Vektor-Smartobjekt"] = 3,
    ["Floor_0003_Vektor-Smartobjekt"] = 4,
    ["Floor_0004_Vektor-Smartobjekt"] = 5,
    ["Floor_0005_Vektor-Smartobjekt"] = 6,
    ["Floor_0006_Vektor-Smartobjekt"] = 7,
    ["Floor_0007_Vektor-Smartobjekt"] = 8,
    ["Floor_0008_Vektor-Smartobjekt"] = 9,
    ["Floor_0009_Vektor-Smartobjekt"] = 10,
    ["Floor_0010_Vektor-Smartobjekt"] = 11,
    ["Floor_0011_Vektor-Smartobjekt"] = 12,
    ["Floor_0012_Vektor-Smartobjekt"] = 13,
    ["platform"] = 14,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
