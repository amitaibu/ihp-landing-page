module Web.Element.ElementWrap where

import Application.Helper.Icons as Icons
import Text.Blaze.Internal
import Web.Element.Types
import Web.View.Prelude

-- Containers

wrapBackgroundColor :: Color -> BackgroundColorPadding -> Html -> Html
wrapBackgroundColor color paddingType element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class={classes'}>{element}</div>|]
    where
        classes' =
            classes
            [ (className, True)
            , ("py-3 px-5", paddingType == BackgroundColorPaddingCard)
            , ("p-8", paddingType == BackgroundColorPaddingSection)
            ]

        className =
            case color of
                ColorTransparent -> "bg-transparent"
                Blue100          -> "bg-blue-100"
                Gray100          -> "bg-gray-100"
                Gray300          -> "bg-gray-300"
                Gray500          -> "bg-gray-500"
                Gray900          -> "bg-gray-900"
                Green600         -> "bg-green-600"
                Red600           -> "bg-red-600"
                Orange100        -> "bg-orange-100"
                White            -> "bg-white"

wrapDetailsWithBackgroundColor :: Color -> Bool -> Html -> Html -> Html
wrapDetailsWithBackgroundColor color isOpen summary element =
    case element of
        Empty _ -> ""
        _ -> [hsx|
            <details open={isOpen} class={classes'}>
                <summary class="flex flex-row items-center gap-x-2 cursor-pointer">
                    {chevron}
                    {summary}
                </summary>

                {- We can't use flex on the `details` tag, so we add padding here
                -}
                <div class="py-5">{element}</div>
            </details>
            |]
    where
        -- heroicons chevron-right.
        chevron = [hsx|
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class={chevronClasses}>
            <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
        </svg>

        |]

        chevronClasses = classes
            [ ("icon-chevron w-4 h-4 transform", True)
            , ("rotate-90", isOpen)
            ]

        classes' =
            classes
            -- Make the color darker based on the background color.
            [ ("border rounded-lg py-3 px-5", True)
            , ("bg-white border-pp-blue", color == White)
            , ("bg-blue-100 border-pp-blue", color == Blue100)
            , ("bg-orange-100 border-pp-orange", color == Orange100)
            ]

{-| Similar theming of `wrapDetailsWithBackgroundColor`, but without the `details` tag. -}
wrapNoDetailsWithBackgroundColor :: Color -> Html -> Html
wrapNoDetailsWithBackgroundColor color element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class={classes'}>{element}</div>|]
    where
        classes' =
            classes
            -- Make the color darker based on the background color.
            [ ("border rounded-lg py-3 px-5", True)
            , ("bg-white border-pp-blue", color == White)
            , ("bg-blue-100 border-pp-blue", color == Blue100)
            , ("bg-orange-100 border-pp-orange", color == Orange100)
            ]

-- | Wrap an element with a wide container.
wrapContainerWide :: Html -> Html
wrapContainerWide element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class="container-wide w-full">{element}</div>|]


-- | Wrap an element with a narrow container.
wrapContainerNarrow :: Html -> Html
wrapContainerNarrow element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class="container-narrow w-full">{element}</div>|]

-- | Wrap an element with a max width.
wrapContainerMaxWidth :: Width -> Html -> Html
wrapContainerMaxWidth width element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class={classes'}>{element}</div>|]
    where
        classes' =
            classes
            [ ("max-w-lg", width == WidthLg)
            , ("max-w-xl", width == WidthXl)
            , ("max-w-2xl", width == Width2xl)
            , ("max-w-3xl", width == Width3xl)
            ]

-- | Wrap an element with rounded corners.
wrapRoundedCorners :: RoundedCorner -> Html -> Html
wrapRoundedCorners roundedCorner element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class={classes'}>{element}</div>|]
    where
        classes' =
            classes
            [ "overflow-hidden"
            , ("rounded-lg", roundedCorner == RoundedCornerLarge)
            , ("rounded-full", roundedCorner == RoundedCornerFull)
            ]

wrapBorder :: RoundedCorner -> Html -> Html
wrapBorder roundedCorner element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class={classes'}>{element}</div>|]
    where
        classes' =
            classes
            [ "border border-gray-300 overflow-hidden"
            , ("rounded-lg", roundedCorner == RoundedCornerLarge)
            , ("rounded-full", roundedCorner == RoundedCornerFull)
            , ("rounded-none", roundedCorner == RoundedCornerNone)
            ]

wrapBottomBorder :: Color -> Html -> Html
wrapBottomBorder color element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class={classes'}>{element}</div>|]
     where
       classes' =
            classes
            [ "border-b"
            , ("border-gray-500", color == Gray500)
            ]

-- Spacing

wrapVerticalSpacing :: Align -> Html -> Html
wrapVerticalSpacing align element =
    wrapVerticalSpacingHelper align element "gap-y-5 md:gap-y-6"

wrapVerticalSpacingBig :: Align -> Html -> Html
wrapVerticalSpacingBig align element =
    wrapVerticalSpacingHelper align element "gap-y-8 md:gap-y-10"

wrapVerticalSpacingTiny :: Align -> Html -> Html
wrapVerticalSpacingTiny align element =
    wrapVerticalSpacingHelper align element "gap-y-2"

wrapVerticalSpacingNone :: Align -> Html -> Html
wrapVerticalSpacingNone align element =
    wrapVerticalSpacingHelper align element "gap-y-0"

wrapVerticalSpacingHelper :: Align -> Html -> Text -> Html
wrapVerticalSpacingHelper align element gapClasses =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class={classes'}>{element}</div>|]
    where
        classes' =
            classes
            [ "flex flex-col"
            , (gapClasses, True)
            , ("items-start", align == AlignStart)
            , ("items-center", align == AlignCenter)
            , ("items-end", align == AlignEnd)
            , ("items-baseline", align == AlignBaseline)
            ]

wrapHorizontalSpacing :: Align -> Html -> Html
wrapHorizontalSpacing align element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class={classes'}>{element}</div>|]
    where
        classes' =
            classes
            [ "flex flex-row gap-4 md:gap-5"
            , ("items-start", align == AlignStart)
            , ("items-center", align == AlignCenter)
            , ("items-end", align == AlignEnd)
            , ("items-baseline", align == AlignBaseline)
            ]

wrapHorizontalSpacingTiny :: Align -> Html -> Html
wrapHorizontalSpacingTiny align element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class={classes'}>{element}</div>|]
    where
        classes' =
            classes
            [ "flex flex-row gap-2"
            , ("items-start", align == AlignStart)
            , ("items-center", align == AlignCenter)
            , ("items-end", align == AlignEnd)
            , ("items-baseline", align == AlignBaseline)
            ]

wrapHorizontalSpacingJustify :: Justify -> Align -> Html -> Html
wrapHorizontalSpacingJustify justify align element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class={classes'}>{element}</div>|]
    where
        classes' =
            classes
            [ "flex flex-row w-full"
            , ("items-start", align == AlignStart)
            , ("items-center", align == AlignCenter)
            , ("items-end", align == AlignEnd)
            , ("items-baseline", align == AlignBaseline)
            , ("justify-start", justify == JustifyStart)
            , ("justify-end", justify == JustifyEnd)
            , ("justify-between", justify == JustifyBetween)
            , ("justify-center", justify == JustifyCenter)
            ]

wrapBottomPadding :: Html -> Html
wrapBottomPadding element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class="pb-8">{element}</div>|]


wrapHorizontalPadding :: Html -> Html
wrapHorizontalPadding element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class="px-8">{element}</div>|]

wrapInlineBlock :: Html -> Html
wrapInlineBlock element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class="inline-block">{element}</div>|]


-- Lists (ul and ol)

wrapListLi :: Html -> Html
wrapListLi element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<li>{element}</li>|]

wrapListOl :: Html -> Html
wrapListOl element =
    case element of
        Empty _ -> ""
        _ -> [hsx|<ol class="list-decimal flex flex-col gap-2">{element}</ol>|]

wrapListUl :: Html -> Html
wrapListUl element =
    case element of
        Empty _ -> ""
        _ -> [hsx|<ol class="list-disc flex flex-col gap-2">{element}</ol>|]

wrapSortableList :: Html -> Html
wrapSortableList element =
    case element of
        Empty _ -> ""
        _ -> [hsx|<ol class="js-sortable flex flex-col gap-y-3">{element}</ol>|]

wrapSortableListLi :: Html -> Html
wrapSortableListLi element =
    case element of
        Empty _ -> ""
        _ -> [hsx|<li class="sortable-handle flex flex-row gap-x-2 items-center">
            {Icons.bars}
            {element}
        </li>|]

-- Text

wrapProse :: Html -> Html
wrapProse element =
    [hsx|
        <div class="prose max-w-none">
            {element}
        </div>
    |]

wrapTextResponsiveFontSize :: TextSize -> Html -> Html
wrapTextResponsiveFontSize textSize element =
    [hsx|
        <div class={sizeClasses}>{element}</div>
    |]
    where
        sizeClasses :: Text =
            case textSize of
                TextSizeXs   -> "text-xs"
                TextSizeSm   -> "text-xs md:text-sm"
                TextSizeBase -> "text-sm md:text-base"
                TextSizeLg   -> "md:text-lg"
                TextSizeXl   -> "text-lg md:text-xl"
                TextSize2xl  -> "text-xl md:text-2xl"
                TextSize3xl  -> "text-xl md:text-2xl lg:text-3xl"

wrapTextFontWeight :: FontWeight -> Html -> Html
wrapTextFontWeight fontweight element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class={weightClasses}>{element}</div>|]
    where
        weightClasses :: Text =
            case fontweight of
                FontWeightLight  -> "font-light"
                FontWeightNormal -> "font-normal"
                FontWeightMedium -> "font-medium"
                FontWeightBold   -> "font-bold"

wrapHeaderTag :: Int -> Html -> Html
wrapHeaderTag number element =
    case number of
        1 -> [hsx|<h1>{element}</h1>|]
        2 -> [hsx|<h2>{element}</h2>|]
        3 -> [hsx|<h3>{element}</h3>|]
        4 -> [hsx|<h4>{element}</h4>|]
        5 -> [hsx|<h5>{element}</h5>|]
        6 -> [hsx|<h6>{element}</h6>|]
        _ -> mempty


wrapTextColor :: Color -> Html -> Html
wrapTextColor color element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class={className}>{element}</div>|]
    where
        className :: Text =
            case color of
                ColorTransparent -> "text-transparent"
                Blue100          -> "text-blue-200"
                Gray100          -> "text-gray-100"
                Gray300          -> "text-gray-300"
                Gray500          -> "text-gray-500"
                Gray900          -> "text-gray-900"
                Green600         -> "text-green-600"
                Red600           -> "text-red-600"
                Orange100        -> "text-orange-100"
                White            -> "text-white"

wrapTextItalic :: Html -> Html
wrapTextItalic element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class="italic">{element}</div>|]

wrapTextCenter :: Html -> Html
wrapTextCenter element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div class="text-center">{element}</div>|]

wrapAnchor :: Text -> Html -> Html
wrapAnchor id element =
    case element of
        Empty _ -> ""
        _       -> [hsx|<div id={id}>{element}</div>|]

wrapCheckboxWrapper :: Html -> Html
wrapCheckboxWrapper element = [hsx|<div class="flex flex-row space-x-2 ml-8 items-center">{element}</div>|]
