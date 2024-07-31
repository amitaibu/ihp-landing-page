module Web.View.ParagraphHeroImages.Edit where
import Web.View.Prelude
import Web.View.ParagraphHeroImages.Form

data EditView = EditView
    { paragraphHeroImage :: ParagraphHeroImage
    , formStatus :: FormStatus
    , landingPage :: LandingPage
    }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Paragraph Hero Image</h1>
        {renderForm paragraphHeroImage False formStatus}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbText "Landing Page"
                , breadcrumbLink (cs landingPage.title) (EditLandingPageAction landingPage.id)
                , breadcrumbText "Edit Hero Image"
                ]
