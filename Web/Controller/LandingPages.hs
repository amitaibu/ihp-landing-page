module Web.Controller.LandingPages where

import Web.Controller.Prelude
import Web.View.LandingPages.Index
import Web.View.LandingPages.New
import Web.View.LandingPages.Edit
import Web.View.LandingPages.Show

instance Controller LandingPagesController where
    action LandingPagesAction = do
        landingPages <- query @LandingPage |> fetch
        redirectToUrl "https://github.com/digitallyinduced/ihp?query=1#hash=2"
        -- render IndexView { .. }

    action NewLandingPageAction = do
        let landingPage = newRecord
        render NewView { .. }

    action ShowLandingPageAction { landingPageId } = do
        landingPageWithRecords <- fetchLandingPageWithRecords landingPageId

        render ShowView { .. }

    action EditLandingPageAction { landingPageId } = do
        landingPageWithRecords <- fetchLandingPageWithRecords landingPageId

        render EditView { .. }

    action UpdateLandingPageAction { landingPageId } = do
        landingPageWithRecords <- fetchLandingPageWithRecords landingPageId


        landingPageWithRecords.landingPage
            |> buildLandingPage
            |> ifValid \case
                Left landingPage' -> do

                    -- Fetch the paragraphs again, because we need to show the validation errors.
                    landingPageWithRecords <- fetchLandingPageWithRecords landingPageId
                    -- Update the Landing page to hold the new input values, and any validation errors.
                    let landingPageWithMeta = landingPageWithRecords.landingPage
                            |> set #meta landingPage'.meta
                            |> set #title landingPage'.title

                    render EditView { landingPageWithRecords = landingPageWithRecords {landingPage = landingPageWithMeta}}

                Right landingPage -> do
                    landingPage <- landingPage |> updateRecord

                    -- After we update the Landing page, we can set the order of the paragraphs.
                    let params = paramListOrNothing @UUID "paragraphId"

                    case catMaybes params of
                        [] -> do
                            -- No paragraphs to update.
                            pure ()

                        uuids -> do
                            -- We need to update the weight of the paragraphs,
                            -- So load them.
                            landingPageWithRecords <- fetchLandingPageWithRecords landingPageId

                            -- Iterate over all paragraphs, and update the weight.
                            forEach landingPageWithRecords.paragraphCtas updateParagraph
                            forEach landingPageWithRecords.paragraphQuotes updateParagraph

                            where
                                updateParagraph :: forall record.
                                        ( HasField "id" record (Id record)
                                        , SetField "weight" record Int
                                        , CanUpdate record
                                        , PrimaryKey (GetTableName record) ~ UUID
                                        , ?modelContext :: ModelContext
                                        ) => record -> IO ()
                                updateParagraph paragraph = do
                                    let uuid :: UUID = unpackId paragraph.id
                                    let weight = elemIndex uuid uuids |> fromMaybe 0

                                    paragraph
                                        |> set #weight weight
                                        |> updateRecord


                                    pure ()

                    setSuccessMessage "LandingPage updated"
                    redirectTo EditLandingPageAction { .. }

    action CreateLandingPageAction = do
        let landingPage = newRecord @LandingPage
        landingPage
            |> buildLandingPage
            |> ifValid \case
                Left landingPage -> render NewView { .. }
                Right landingPage -> do
                    landingPage <- landingPage |> createRecord
                    setSuccessMessage "LandingPage created"
                    -- After we create the Landing page, we can start adding Paragraphs to it.
                    redirectTo EditLandingPageAction { landingPageId = landingPage.id }

    action DeleteLandingPageAction { landingPageId } = do
        landingPage <- fetch landingPageId
        deleteRecord landingPage
        setSuccessMessage "LandingPage deleted"
        redirectTo LandingPagesAction

buildLandingPage landingPage = landingPage
    |> fill @'["title"]
    |> validateField #title nonEmpty

