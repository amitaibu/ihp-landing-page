module Web.View.ParagraphQuotes.Form where

import Web.View.Prelude
import Web.Element.Types
import Web.Element.ElementWrap
import Web.Element.SubmitButton

{-| When editing the form, the image input field isn't required.
That is, the image itself is required, but since we've already uploaded one,
when editing, we don't require re-uploading the same image.
-}
renderForm :: ParagraphQuote -> Bool -> FormStatus -> Html
renderForm paragraphQuote isImageRequired formStatus = formFor paragraphQuote [hsx|
    {(hiddenField #landingPageId)}
    {(hiddenField #weight)}
    {visibleForm paragraphQuote}
    |]
    where
        visibleForm :: (?formContext :: FormContext ParagraphQuote) => ParagraphQuote -> Html
        visibleForm paragraphQuote =
            [hsx|
                {(textareaField #body) {required = True}}
                {(textField #subtitle) {required = True}}

                <div class="flex flex-row">
                    {(fileField #imageUrl) {required = isImageRequired, additionalAttributes = [("accept", "image/*"), ("data-preview", "#imageUrlPreview")]}}

                    <img id="imageUrlPreview" src={paragraphQuote.imageUrl} class="w-20 h-20" />
                </div>

                {renderSubmitButtonWithFormStatus submitButton formStatus}
            |]
            |> wrapVerticalSpacing AlignNone
            |> wrapContainerWide



