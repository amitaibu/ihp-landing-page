module Web.Controller.ParagraphCtas where

import Web.Controller.Prelude
import Web.View.ParagraphCtas.New
import Web.View.ParagraphCtas.Edit

instance Controller ParagraphCtasController where

    action NewParagraphCtaAction { landingPageId } = do
        weight <- getParagraphsCount landingPageId

        let paragraphCta = newRecord
                |> set #landingPageId landingPageId
                |> set #weight weight

        -- Get all landing pages, so we can select the one we want to link to.
        landingPages <- query @LandingPage |> fetch
        landingPage <- fetch paragraphCta.landingPageId

        render NewView { .. }

    action EditParagraphCtaAction { paragraphCtaId } = do
        paragraphCta <- fetch paragraphCtaId

        -- Get all landing pages, so we can select the one we want to link to.
        landingPages <- query @LandingPage |> fetch
        landingPage <- fetch paragraphCta.landingPageId

        render EditView { .. }

    action UpdateParagraphCtaAction { paragraphCtaId } = do
        paragraphCta <- fetch paragraphCtaId
        paragraphCta
            |> buildParagraphCta
            |> ifValid \case
                Left paragraphCta -> do
                    landingPages <- query @LandingPage |> fetch
                    landingPage <- fetch paragraphCta.landingPageId
                    render EditView { .. }
                Right paragraphCta -> do
                    paragraphCta <- paragraphCta |> updateRecord
                    setSuccessMessage "ParagraphCta updated"
                    redirectTo EditLandingPageAction { landingPageId = paragraphCta.landingPageId }

    action CreateParagraphCtaAction = do
        let paragraphCta = newRecord @ParagraphCta
        paragraphCta
            |> buildParagraphCta
            |> ifValid \case
                Left paragraphCta -> do
                    landingPages <- query @LandingPage |> fetch
                    landingPage <- fetch paragraphCta.landingPageId
                    render NewView { .. }
                Right paragraphCta -> do
                    paragraphCta <- paragraphCta |> createRecord
                    setSuccessMessage "ParagraphCta created"
                    redirectTo EditLandingPageAction { landingPageId = paragraphCta.landingPageId }

    action DeleteParagraphCtaAction { paragraphCtaId } = do
        paragraphCta <- fetch paragraphCtaId
        deleteRecord paragraphCta
        setSuccessMessage "ParagraphCta deleted"
        redirectTo EditLandingPageAction { landingPageId = paragraphCta.landingPageId }

buildParagraphCta paragraphCta = paragraphCta
    |> fill @'["landingPageId", "weight", "title", "body", "refLandingPageId"]
    |> validateField #title nonEmpty
    |> validateField #body nonEmpty
    |> validateField #refLandingPageId nonEmpty
