module Web.View.Companies.Index where
import Web.View.Prelude

data IndexView = IndexView { companies :: [Company]  }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewCompanyAction} class="btn btn-primary ms-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Company</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach companies renderCompany}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Companies" CompaniesAction
                ]

renderCompany :: Company -> Html
renderCompany company = [hsx|
    <tr>
        <td>{company}</td>
        <td><a href={ShowCompanyAction company.id}>Show</a></td>
        <td><a href={EditCompanyAction company.id} class="text-muted">Edit</a></td>
        <td><a href={DeleteCompanyAction company.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]