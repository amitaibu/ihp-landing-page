module Web.Element.Types where
import Web.View.Prelude

data Align = AlignNone | AlignStart | AlignCenter | AlignEnd | AlignBaseline deriving (Eq, Show)

data Justify = JustifyStart | JustifyCenter | JustifyEnd | JustifyBetween deriving (Eq, Show)

data FontWeight = FontWeightLight | FontWeightNormal | FontWeightMedium | FontWeightBold deriving (Eq, Show)

data Color
    = ColorTransparent
    | Blue100
    | Gray100
    | Gray300
    | Gray500
    | Gray900
    | Green600
    | Orange100
    | Red600
    | White
    deriving (Eq, Show)

data TextSize = TextSizeXs | TextSizeSm | TextSizeBase | TextSizeLg | TextSizeXl | TextSize2xl | TextSize3xl deriving (Eq, Show)

data LinkType = LinkTypeNoDelete | LinkTypeDeleteWithConfirmation | LinkTypeDeleteWithoutConfirmation deriving (Eq, Show)

data RoundedCorner = RoundedCornerNone | RoundedCornerLarge | RoundedCornerFull deriving (Eq, Show)

-- | The padding around the background color.
data BackgroundColorPadding
    = BackgroundColorPaddingCard -- Used for example for comments.
    | BackgroundColorPaddingSection -- Used for example for the footer.
    deriving (Eq, Show)

data Width = WidthLg | WidthXl | Width2xl | Width3xl deriving (Eq, Show)


-- Render types

data RenderButton = RenderButton
    { text      :: Text
    , url       :: Text
    , isPrimary :: Bool
    }

data RenderLink = RenderLink
    { text :: Text
    , url  :: Text
    }

data RenderCta = RenderCta
    { title  :: Text
    , body   :: Text
    , button :: RenderButton
    }

data RenderQuote = RenderQuote
    { body     :: Text
    , subtitle :: Text
    , imageUrl :: Text
    }

data RenderHeroImage = RenderHeroImage
    { title         :: Text
    , maybeSubtitle :: Maybe Text
    , imageUrl      :: Text
    , maybeButton   :: Maybe RenderButton
    }


-- @todo: Move to Utility.hs?
getBackgroundColor :: Color -> Text
getBackgroundColor color =
    case color of
        ColorTransparent -> "bg-transparent"
        Blue100          -> "bg-blue-100"
        Gray100          -> "bg-gray-100"
        Gray300          -> "bg-gray-300"
        Gray500          -> "bg-gray-500"
        Gray900          -> "bg-gray-900"
        Green600         -> "bg-green-600"
        Orange100        -> "bg-orange-100"
        Red600           -> "bg-red-600"
        White            -> "bg-white"
