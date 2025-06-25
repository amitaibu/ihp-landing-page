module Web.View.ParagraphHeroImages.Form where

import Web.View.Prelude
import Web.Element.Types
import Web.Element.ElementWrap
import Web.Element.SubmitButton

{-| When editing the form, the image input field isn't required.
That is, the image itself is required, but since we've already uploaded one,
when editing, we don't require re-uploading the same image.
-}
renderForm :: ParagraphHeroImage -> Bool -> FormStatus -> Html
renderForm paragraphHeroImage isImageRequired formStatus = formFor paragraphHeroImage [hsx|
    {(hiddenField #landingPageId)}
    {(hiddenField #weight)}
    {visibleForm paragraphHeroImage}
    |]
    where
        visibleForm :: (?formContext :: FormContext ParagraphHeroImage) => ParagraphHeroImage -> Html
        visibleForm paragraphHeroImage =
            [hsx|
                {(textField #title) {required = True}}
                {(textField #subtitle)}
                {(textField #link)}

                <div class="flex flex-row">
                    {(fileField #imageUrl) {required = isImageRequired, additionalAttributes = [("accept", "image/*"), ("data-preview", "#imageUrlPreview")]}}

                    <img id="imageUrlPreview" src={paragraphHeroImage.imageUrl} class="w-20 h-20" />
                </div>

                {renderSubmitButtonwithFormStatus (submitButton {label = "Save Hero Image"}) formStatus}
            |]
            |> wrapVerticalSpacing AlignNone
            |> wrapContainerWide
