module Web.View.StyleGuide.Index where
import Data.Text
import Web.Element.Types
import Web.View.Prelude

import Web.Element.Cta
import Web.Element.HeroImage
import Web.Element.PageTitle
import Web.Element.Quote

data IndexView = IndexView { }

instance View IndexView where
    html IndexView { .. } =
        [ breadcrumb
        , elementsAccordion

        -- Include the JavaScript for the accordion.
        , jsScript
        ]
        |> mconcat
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Style Guide" StyleGuideAction
                ]

            elementsAccordion = [hsx|
                <dl class="accordion">
                    { elements }
                </dl>
            |]

            jsScript = [hsx|
                <script src={assetPath "/styleGuide.js"}></script>
            |]

            -- All the elements to be displayed in the Style Guide.
            elements =
                [ renderTitleAndElementWideContainer "Page Title" pageTitle
                , renderTitleAndElementNoContainer "CTA" cta
                , renderTitleAndElementNoContainer "Quote" quote
                , renderTitleAndElementNoContainer "Hero Image" heroImage
                ]
                |> mconcat

            pageTitle = "The source has extended, but not everyone fears it"
                |> Web.Element.PageTitle.render

            cta = RenderCta
                { title = "Hello, World!"
                , body = "This is a test of the __emergency__ broadcast system."
                , button = RenderButton
                    { text = "Click me!"
                    , url = "/"
                    , isPrimary = False
                    }
                }
                |> Web.Element.Cta.render

            quote = RenderQuote
                { body = "The quick brown fox jumps over the lazy dog"
                , subtitle = "An old proverb"
                , imageUrl = "/styleGuideImages/8f8827de-e5d4-4ee7-b0a3-abae36274338"
                }
                |> Web.Element.Quote.render

            heroImage = RenderHeroImage
                { title = "This is title"
                , maybeSubtitle = "This is subtitle"
                , imageUrl = "/styleGuideImages/8f8827de-e5d4-4ee7-b0a3-abae36274338"
                , maybeButton = Just RenderButton
                    { text = "Read more"
                    , url = "/"
                    , isPrimary = True
                    }
                }
                |> Web.Element.HeroImage.render

renderTitleAndElementNoContainer :: Text -> Html -> Html
renderTitleAndElementNoContainer title element =
    renderTitleAndElementHelper title Nothing element Nothing

renderTitleAndElementWideContainer :: Text -> Html -> Html
renderTitleAndElementWideContainer title element =
    renderTitleAndElementHelper title Nothing element (Just "container-wide")

renderTitleAndElementHelper :: Text -> Maybe Text -> Html -> Maybe Text -> Html
renderTitleAndElementHelper title maybeUrl element maybeContainerClass  = [hsx|
        { header }
        <dd class={"mb-8 " ++ maybeContainerClass}>
            { element }
        </dd>
    |]


    where
        uniqueId = title |> toLower |> Data.Text.replace " " "-"

        header = [hsx|
            <dt class="container-wide my-6">
                <a class="title-wrapper text-blue-500 text-2xl hover:underline" href={ "#" ++ uniqueId } id={ uniqueId }>{ title }</a>

                { maybeLink }
            </dt>
        |]

        maybeLink = case maybeUrl of
            Just url -> [hsx|
                <div class="ml-4">
                    <a class="text-sm" href={ url } target="_blank">See design</a>
                </div>
            |]
            Nothing -> ""
