module Web.View.ParagraphCtas.Edit where
import Web.View.Prelude
import Web.Element.Types
import Web.Element.ElementWrap


data EditView = EditView
    { paragraphCta :: ParagraphCta
    , landingPages :: [LandingPage]
    , landingPage :: LandingPage
    }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit ParagraphCta</h1>
        {renderForm paragraphCta landingPages}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbText "Landing Page"
                , breadcrumbLink (cs landingPage.title) (EditLandingPageAction landingPage.id)
                , breadcrumbText "Edit CTA"
                ]

renderForm :: ParagraphCta -> [LandingPage] -> Html
renderForm paragraphCta landingPages = formFor paragraphCta [hsx|
    {(hiddenField #landingPageId)}
    {(hiddenField #weight)}
    {visibleForm paragraphCta landingPages}

|]
    where
            visibleForm paragraphCta landingPages =
                [hsx|
                    {(textField #title) {required = True}}
                    {(textareaField #body) {required = True}}
                    {(selectField #refLandingPageId landingPages) {required = True, fieldLabel = "Landing page", helpText = "Select the landing page you want to link to."}}
                    {submitButton}
                |]
                |> wrapVerticalSpacing AlignNone
                |> wrapContainerWide
