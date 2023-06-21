module Web.View.Companies.Show where
import Web.View.Prelude

data ShowView = ShowView { companyWithRecords :: CompanyWithRecords }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show Company</h1>
        <p>{companyWithRecords.company.name}</p>
        <img class="w-20" src={companyWithRecords.uploadedFile.signedUrl} />
        <a href={companyWithRecords.uploadedFile.signedUrl} download={companyWithRecords.uploadedFile.fileName}>Download</a>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Companies" CompaniesAction
                            , breadcrumbText "Show Company"
                            ]