module Web.Controller.Companies where

import Web.Controller.Prelude
import Web.View.Companies.Index
import Web.View.Companies.New
import Web.View.Companies.Edit
import Web.View.Companies.Show

-- @todo: Add to Guide
import qualified Network.Wai.Parse as Wai


instance Controller CompaniesController where
    action CompaniesAction = do
        companies <- query @Company |> fetch
        render IndexView { .. }

    action NewCompanyAction = do
        let company = newRecord
        render NewView { .. }

    action ShowCompanyAction { companyId } = do
        companyWithRecords <- fetchCompanyWithRecords companyId

        let uploadedFile = companyWithRecords.uploadedFile
        uploadedFile <- refreshTemporaryDownloadUrlFromFile uploadedFile
        let companyWithRecords = companyWithRecords
                |> set #uploadedFile uploadedFile

        render ShowView { .. }

    action EditCompanyAction { companyId } = do
        company <- fetch companyId
        render EditView { .. }

    action UpdateCompanyAction { companyId } = do
        company <- fetch companyId
        company
            |> buildCompany
            |> ifValid \case
                Left company -> render EditView { .. }
                Right company -> do
                    company <- company |> updateRecord
                    setSuccessMessage "Company updated"
                    redirectTo EditCompanyAction { .. }

    action CreateCompanyAction = do
        -- Upload file. If no file provided, we error and short-circuit.
        let file = fileOrNothing "uploadedFile" |> fromMaybe (error "no file given")

        let options :: StoreFileOptions = def
                { directory = "uploaded_files"
                , contentDisposition = contentDispositionAttachmentAndFileName
                }

        -- Store the file, and get the signed URL.
        storedFile <- storeFileWithOptions file options
        signedUrl <- createTemporaryDownloadUrl storedFile

        -- Create the UploadedFile record. Set the signed URL, path, content-type etc.
        uploadedFile <- newRecord @UploadedFile
            |> set #signedUrl signedUrl.url
            |> set #signedUrlExpiredAt signedUrl.expiredAt
            |> set #path storedFile.path
            |> set #fileName (cs file.fileName)
            |> set #contentType (cs $ Wai.fileContentType file)
            |> createRecord

        let company = newRecord @Company
        company
            |> buildCompany
            -- Reference the newly created UploadedFile record.
            |> set #uploadedFileId uploadedFile.id
            |> ifValid \case
                Left company -> render NewView { .. }
                Right company -> do
                    company <- company |> createRecord
                    setSuccessMessage "Company created"
                    redirectTo ShowCompanyAction { companyId = company.id }

    action DeleteCompanyAction { companyId } = do
        company <- fetch companyId
        deleteRecord company
        setSuccessMessage "Company deleted"
        redirectTo CompaniesAction

buildCompany company = company
    |> fill @'["name"]
