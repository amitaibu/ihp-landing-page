module Web.Element.HeroImage where

import Web.View.Prelude

import Web.Element.ElementWrap
import Web.Element.Types
import Web.Element.Button

render :: RenderHeroImage -> Html
render record@RenderHeroImage {title, maybeSubtitle, maybeButton, imageUrl} =
     titleWrapped
        ++ subTitleWrapped
        ++ renderedButton
        |> wrapVerticalSpacingBig AlignNone
        |> renderImageAndContent (pathTo $ RenderImageStyleAction 1536 466 imageUrl signed)
    where
        -- Sign the image URL to prevent tampering.
        signed = signImageUrl imageUrl 1536 466

        titleWrapped = cs title
            |> wrapHeaderTag 1
            |> wrapTextFontWeight FontWeightBold
            |> wrapTextResponsiveFontSize TextSizeSm

        subTitleWrapped = maybeSubtitle 
            |> fmap (\subtitle -> cs subtitle 
                |> wrapTextFontWeight FontWeightMedium 
                |> wrapTextResponsiveFontSize TextSizeXl
            ) 
            |> fromMaybe ""

        renderedButton = maybeButton |> fmap Web.Element.Button.render |> fromMaybe ""


renderImageAndContent :: Text -> Html -> Html
renderImageAndContent imageUrl items =
    [hsx|
        <div class="grid grid-rows-1">
            <figure class="row-start-1 col-start-1 child-object-cover">
                {image}
            </figure>

            <div class="row-start-1 col-start-1 z-10 flex flex-col justify-center">
                <div class="container-wide w-full">
                    <div class="max-w-prose my-6 md:my-8 p-6 md:p-8 lg:p-10 bg-white/90 flex flex-col gap-3 md:gap-4 lg:gap-5 rounded-lg">
                        {items}
                    </div>
                </div>
            </div>
        </div>
    |]
    where
        image = [hsx|<img src={imageUrl} class="w-full h-full" />|]


