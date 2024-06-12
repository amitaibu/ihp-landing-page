module Web.View.Projects.New where
import Web.View.Prelude

data NewView = NewView { project :: Project }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Project</h1>
        {renderForm project}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Projects" ProjectsAction
                , breadcrumbText "New Project"
                ]

renderForm :: Project -> Html
renderForm project = formFor project [hsx|
    {(selectField #projectType allProjectTypes)}
    {(numberField #participants)}
    {submitButton}
|]
    where allProjectTypes = allEnumValues @ProjectType