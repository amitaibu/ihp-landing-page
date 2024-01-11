module Web.View.LandingPages.Index where
import Web.View.Prelude
import Web.Element.Types
import Web.Element.ElementBuild
import Web.Element.ElementWrap

data IndexView = IndexView { landingPages :: [LandingPage]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        {header}
        {body}

    |]
        |> wrapVerticalSpacing AlignNone
        |> wrapContainerWide
        where
            header =
                [ [hsx|Landing pages Index|] |> wrapHeaderTag 1
                , buildButton (pathTo NewLandingPageAction) "New Landing page"
                ]
                    |> mconcat
                    |> wrapHorizontalSpacing AlignNone

            body = forEach landingPages renderLandingPage |> wrapListOl

            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Landing Pages" LandingPagesAction
                ]

renderLandingPage :: LandingPage -> Html
renderLandingPage landingPage = [hsx|
    <div id={landingPage.id}>
        {body}
    </div>
|]
    where
        body =
            [ cs landingPage.title
            , operations
            ]
                |> mconcat
                |> wrapHorizontalSpacingTiny AlignBaseline
        operations =
            [ buildLink (ShowLandingPageAction landingPage.id) "Show"
            , buildLink (EditLandingPageAction landingPage.id) "Edit"
            , buildLinkDeleteAction (DeleteLandingPageAction landingPage.id)
            ]
                |> mconcat
                |> wrapHorizontalSpacingTiny AlignCenter