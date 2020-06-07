module JungleHelperRemoteKevins

using ..Ahorn, Maple

@mapdef Entity "JungleHelper/RemoteKevin" RemoteKevin(x::Integer, y::Integer, restrained::Bool=false, multiplier::Number=57.5)

const placements = Ahorn.PlacementDict(
    "Slide Block (Restraintless, Jungle Helper)" => Ahorn.EntityPlacement(
        RemoteKevin,
        "rectangle",
        Dict{String, Any}(
            "restrained" => false
        )
    ),
    "Slide Block (Restrained, Jungle Helper)" => Ahorn.EntityPlacement(
        RemoteKevin,
        "rectangle",
        Dict{String, Any}(
            "restrained" => true
        )
    )
)

frameImage = Dict{String, String}(
    "none" => "objects/crushblock/block00",
    "horizontal" => "objects/crushblock/block01",
    "vertical" => "objects/crushblock/block02",
    "both" => "objects/crushblock/block03"
)

smallFace = "objects/crushblock/idle_face"
giantFace = "objects/crushblock/giant_block00"

kevinColor = (98, 34, 43) ./ 255

Ahorn.minimumSize(entity:: RemoteKevin) = 24, 24
Ahorn.resizable(entity:: RemoteKevin) = true, true

Ahorn.selection(entity:: RemoteKevin) = Ahorn.getEntityRectangle(entity)

function Ahorn.render(ctx::Ahorn.Cairo.CairoContext, entity:: RemoteKevin, room::Maple.Room)
    axes = lowercase(get(entity.data, "axes", "both"))
    chillout = get(entity.data, "chillout", false)

    x, y = Ahorn.position(entity)

    width = Int(get(entity.data, "width", 32))
    height = Int(get(entity.data, "height", 32))

    giant = height >= 48 && width >= 48 && chillout
    face = giant ? giantFace : smallFace
    frame = frameImage[lowercase(axes)]
    faceSprite = Ahorn.getSprite(face, "Gameplay")

    tilesWidth = div(width, 8)
    tilesHeight = div(height, 8)

    Ahorn.drawRectangle(ctx, 2, 2, width - 4, height - 4, kevinColor)
    Ahorn.drawImage(ctx, faceSprite, div(width - faceSprite.width, 2), div(height - faceSprite.height, 2))

    for i in 2:tilesWidth - 1
        Ahorn.drawImage(ctx, frame, (i - 1) * 8, 0, 8, 0, 8, 8)
        Ahorn.drawImage(ctx, frame, (i - 1) * 8, height - 8, 8, 24, 8, 8)
    end

    for i in 2:tilesHeight - 1
        Ahorn.drawImage(ctx, frame, 0, (i - 1) * 8, 0, 8, 8, 8)
        Ahorn.drawImage(ctx, frame, width - 8, (i - 1) * 8, 24, 8, 8, 8)
    end

    Ahorn.drawImage(ctx, frame, 0, 0, 0, 0, 8, 8)
    Ahorn.drawImage(ctx, frame, width - 8, 0, 24, 0, 8, 8)
    Ahorn.drawImage(ctx, frame, 0, height - 8, 0, 24, 8, 8)
    Ahorn.drawImage(ctx, frame, width - 8, height - 8, 24, 24, 8, 8)
end

end