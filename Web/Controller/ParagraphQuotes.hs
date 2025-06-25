module Web.Controller.ParagraphQuotes where

import Web.Controller.Prelude
import Web.View.ParagraphQuotes.New
import Web.View.ParagraphQuotes.Edit

instance Controller ParagraphQuotesController where
    action NewParagraphQuoteAction { .. } = do
        weight <- getParagraphsCount landingPageId
        let paragraphQuote = newRecord
                |> set #landingPageId landingPageId
                |> set #weight weight

        let formStatus = FormStatusNotSubmitted
        landingPage <- fetch paragraphQuote.landingPageId

        render NewView { .. }

    action EditParagraphQuoteAction { paragraphQuoteId } = do
        paragraphQuote <- fetch paragraphQuoteId
        landingPage <- fetch paragraphQuote.landingPageId
        -- Get from the session, if the form was submitted successfully.
        formStatus <- getAndClearFormStatus
        render EditView { .. }

    action UpdateParagraphQuoteAction { paragraphQuoteId } = do
        createOrUpdateParagraphQuoteAction (Just paragraphQuoteId)

    action CreateParagraphQuoteAction = do
        createOrUpdateParagraphQuoteAction Nothing

    action DeleteParagraphQuoteAction { paragraphQuoteId } = do
        paragraphQuote <- fetch paragraphQuoteId
        deleteRecord paragraphQuote
        setSuccessMessage "Quote deleted"
        redirectTo EditLandingPageAction { landingPageId = paragraphQuote.landingPageId }

buildParagraphQuote paragraphQuote = paragraphQuote
    |> fill @["landingPageId", "weight", "subtitle", "body"]
    |> validateField #subtitle nonEmpty
    |> validateField #body nonEmpty
    |> validateField #imageUrl nonEmpty
    |> return

createOrUpdateParagraphQuoteAction :: (?modelContext :: ModelContext, ?context :: ControllerContext) => Maybe (Id ParagraphQuote) -> IO ()
createOrUpdateParagraphQuoteAction maybeParagraphQuoteId = do
    let uploadImage = uploadToStorageWithOptions $ def
            { preprocess = applyImageMagick "jpg" ["-resize", "1024x1024^", "-gravity", "north", "-extent", "1024x1024", "-quality", "85%", "-strip"] }

    formStatus <- getAndClearFormStatus

    paragraphQuote <- case maybeParagraphQuoteId of
        Just id -> fetch id
        Nothing -> pure $ newRecord @ParagraphQuote

    paragraphQuote
        |> uploadImage #imageUrl
        >>= buildParagraphQuote
        >>= ifValid \case
            Left paragraphQuote -> do
                setFormStatus FormStatusError
                landingPage <- fetch paragraphQuote.landingPageId
                if isJust maybeParagraphQuoteId
                    then render EditView { .. }
                    else render NewView { .. }
            Right paragraphQuote -> do
                paragraphQuote <- case maybeParagraphQuoteId of
                    Just _  -> paragraphQuote |> updateRecord
                    Nothing -> paragraphQuote |> createRecord
                setSuccessMessage "Hero Image saved"
                -- We don't setFormStatus, since we redirect to a new page.
                redirectTo EditLandingPageAction { landingPageId = paragraphQuote.landingPageId }