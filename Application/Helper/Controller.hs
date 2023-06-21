module Application.Helper.Controller where

import IHP.ControllerPrelude
import Generated.Types
import Web.Types
import Config
import Crypto.PubKey.RSA as RSA
import Data.ByteString.Base64 as Base64
import Crypto.PubKey.RSA.PKCS15 as RSA.PKCS15
import Crypto.Hash.Algorithms as Hash.Algorithms


-- Here you can add functions which are available in all your controllers

fetchCompanyWithRecords :: (?modelContext :: ModelContext) => Id Company -> IO CompanyWithRecords
fetchCompanyWithRecords companyId = do
    company <- fetch companyId
    uploadedFile <- fetch company.uploadedFileId
    pure $ CompanyWithRecords { .. }

fetchLandingPageWithRecords :: (?modelContext :: ModelContext) => Id LandingPage -> IO LandingPageWithRecords
fetchLandingPageWithRecords landingPageId = do

    landingPage <- fetch landingPageId
    paragraphCtas <- fetch landingPage.paragraphCtasRefLandingPages

    -- Landing pages referenced by ParagraphCta.refLandingPageId
    paragraphCtaRefLandingPages <- query @LandingPage
        |> filterWhereIn (#id, map (get #refLandingPageId) paragraphCtas)
        |> fetch

    paragraphQuotes <- fetch landingPage.paragraphQuotes

    return $ LandingPageWithRecords { .. }

getParagraphsCount :: (?modelContext::ModelContext) => Id LandingPage -> IO Int
getParagraphsCount landingPageId = do
    landingPageWithRecords <- fetchLandingPageWithRecords landingPageId

    pure $ length landingPageWithRecords.paragraphCtas
                    + length landingPageWithRecords.paragraphQuotes
                    + 1

-- | The RSA public key, can be used to verify image style URLs that were signed.
rsaPublicKey :: (?context :: ControllerContext) => RSA.PublicKey
rsaPublicKey = (getAppConfig @Config.RsaKeys).publicKey

-- | The RSA private key, can be used to sign image style URLs.
rsaPrivateKey :: (?context :: ControllerContext) => RSA.PrivateKey
rsaPrivateKey = (getAppConfig @Config.RsaKeys).privateKey

rsaSignatureMatches :: (?context :: ControllerContext) =>  Text -> Text -> Bool
rsaSignatureMatches original signature = case Base64.decode $ cs signature of
    Left msg -> False
    Right decodedSignature -> RSA.PKCS15.verify (Just Hash.Algorithms.SHA256) rsaPublicKey (cs original) decodedSignature