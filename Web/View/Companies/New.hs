module Web.View.Companies.New where
import Web.View.Prelude

data NewView = NewView { company :: Company }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Company</h1>
        {renderForm company}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Companies" CompaniesAction
                , breadcrumbText "New Company"
                ]

renderForm :: Company -> Html
renderForm company = formFor company [hsx|
    {(textField #name)}

    <input
        type="file"
        name="uploadedFile"
        class="form-control-file"
        accept="image/*"
    />

    {submitButton}

|]