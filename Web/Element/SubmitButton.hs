module Web.Element.SubmitButton where

import Web.View.Prelude

import Application.Helper.Icons
import Web.Element.ElementWrap
import Web.Element.Types

renderSubmitButtonWithFormStatus :: SubmitButton -> FormStatus -> Html
renderSubmitButtonWithFormStatus submitButton formStatus = [hsx|
    {submitButton}

    {- We show only one of these messages -}
    <div class="form-status">
        {formStatusMessage}
    </div>
|]
    |> wrapHorizontalSpacing AlignEnd
    where
        formStatusWrapper element = [hsx|<div class="form-status">{element}</div>|]
        maybeFormStatusMessage =
            case formStatus of
                FormStatusNotSubmitted -> Nothing

                FormStatusSuccess ->
                    "Changes saved"
                        |> wrapTextColor Green600
                        |> Just

                FormStatusError ->
                    "Errors in the form"
                        |> wrapTextColor Red600
                        |> Just

        formStatusMessage = maybeFormStatusMessage
            |> fromMaybe ""
            |> wrapTextItalic
            |> \e -> [hsx|<div class="form-status-wrapper">{e}</div>|]

