module Web.View.Companies.Edit where
import Web.View.Prelude

data EditView = EditView { company :: Company }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Company</h1>
        {renderForm company}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Companies" CompaniesAction
                , breadcrumbText "Edit Company"
                ]

renderForm :: Company -> Html
renderForm company = formFor company [hsx|
    {(textField #name)}
    {(textField #uploadedFileId)}
    {submitButton}

|]