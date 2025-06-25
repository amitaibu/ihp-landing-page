module Web.View.LandingPages.Order where

import Web.Element.Cta
import Web.Element.ElementWrap
import Web.Element.Link
import Web.Element.Types
import Web.Element.Quote
import Web.Element.ElementWrap
import Web.Types
import Web.View.Prelude

data OrderParagraphsView = OrderParagraphsView { landingPageWithRecords :: LandingPageWithRecords }

instance View OrderParagraphsView where
    html OrderParagraphsView { .. } =
        [ header
        , orderAndRenderParagraphs landingPageWithRecords
        ]
        |> mconcat
        |> wrapVerticalSpacing AlignNone
        |> wrapContainerWide
        where
            landingPage = landingPageWithRecords.landingPage

            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "LandingPages" LandingPagesAction
                            , breadcrumbText "Show LandingPage"
                            ]

            header =
                [ breadcrumb
                , titleAndEdit
                ]
                |> mconcat
                |> wrapVerticalSpacing AlignNone
                |> wrapContainerWide


            titleAndEdit =
                [ cs ("Re-Order Paragraphs" :: Text) |> wrapHeaderTag 1
                , renderLinkAction (EditLandingPageAction landingPage.id) "back"
                ]
                    |> mconcat
                    |> wrapHorizontalSpacingTiny AlignBaseline


orderAndRenderParagraphs :: (?context::ControllerContext) => LandingPageWithRecords -> Html
orderAndRenderParagraphs landingPageWithRecords =
    ctas ++ quotes
        -- Order by weight.
        |> sortOn fst
        |> fmap snd
        |> fmap wrapSortableListLi
        |> mconcat
        |> wrapSortableList
    where

        ctas = landingPageWithRecords.paragraphCtas
            |> fmap (\paragraph ->
                ( paragraph.weight
                , cs paragraph.title
                )
            )

        quotes = landingPageWithRecords.paragraphQuotes
            |> fmap (\paragraph ->
                ( paragraph.weight
                , cs paragraph.body
                )
            )
