module Web.Controller.ParagraphHeroImages where

import Web.Controller.Prelude
import Web.View.ParagraphHeroImages.New
import Web.View.ParagraphHeroImages.Edit

instance Controller ParagraphHeroImagesController where
    action NewParagraphHeroImageAction { .. } = do
        weight <- getParagraphsCount landingPageId
        let paragraphHeroImage = newRecord
                |> set #landingPageId landingPageId
                |> set #weight weight

        let formStatus = FormStatusNotSubmitted
        landingPage <- fetch paragraphHeroImage.landingPageId

        render NewView { .. }

    action EditParagraphHeroImageAction { paragraphHeroImageId } = do
        paragraphHeroImage <- fetch paragraphHeroImageId
        -- Get from the session, if the form was submitted successfully.
        formStatus <- getAndClearFormStatus
        landingPage <- fetch paragraphHeroImage.landingPageId

        render EditView { .. }

    action UpdateParagraphHeroImageAction { paragraphHeroImageId } = do
        createOrUpdateParagraphHeroImageAction (Just paragraphHeroImageId)

    action CreateParagraphHeroImageAction = do
        createOrUpdateParagraphHeroImageAction Nothing

    action DeleteParagraphHeroImageAction { paragraphHeroImageId } = do
        paragraphHeroImage <- fetch paragraphHeroImageId
        deleteRecord paragraphHeroImage
        setSuccessMessage "Hero Image deleted"
        redirectTo EditLandingPageAction { landingPageId = paragraphHeroImage.landingPageId }

buildParagraphHeroImage paragraphHeroImage = paragraphHeroImage
    |> fill @["landingPageId", "weight", "title", "subtitle", "link"]
    |> validateField #title nonEmpty
    |> validateField #imageUrl nonEmpty
    |> pure

createOrUpdateParagraphHeroImageAction :: (?modelContext :: ModelContext, ?context :: ControllerContext) => Maybe (Id ParagraphHeroImage) -> IO ()
createOrUpdateParagraphHeroImageAction maybeParagraphHeroImageId = do
    let uploadImage = uploadToStorageWithOptions $ def
            { preprocess = applyImageMagick "jpg" ["-resize", "1024x1024^", "-gravity", "north", "-extent", "1024x1024", "-quality", "85%", "-strip"] }

    formStatus <- getAndClearFormStatus

    paragraphHeroImage <- case maybeParagraphHeroImageId of
        Just id -> fetch id
        Nothing -> pure $ newRecord @ParagraphHeroImage

    paragraphHeroImage
        |> uploadImage #imageUrl
        >>= buildParagraphHeroImage
        >>= ifValid \case
            Left paragraphHeroImage -> do
                setFormStatus FormStatusError
                landingPage <- fetch paragraphHeroImage.landingPageId
                if isJust maybeParagraphHeroImageId
                    then render EditView { .. }
                    else render NewView { .. }
            Right paragraphHeroImage -> do
                paragraphHeroImage <- case maybeParagraphHeroImageId of
                    Just _  -> paragraphHeroImage |> updateRecord
                    Nothing -> paragraphHeroImage |> createRecord
                setSuccessMessage "Hero Image saved"
                -- We don't setFormStatus, since we redirect to a new page.
                redirectTo EditLandingPageAction { landingPageId = paragraphHeroImage.landingPageId }
