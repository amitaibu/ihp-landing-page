module Application.Helper.Controller where

import IHP.ControllerPrelude
import Generated.Types
import Web.Types
import Config
import "cryptonite" Crypto.PubKey.RSA as RSA
import Data.ByteString.Base64 as Base64
import "cryptonite" Crypto.PubKey.RSA.PKCS15 as RSA.PKCS15
import "cryptonite" Crypto.Hash.Algorithms as Hash.Algorithms


-- Here you can add functions which are available in all your controllers

fetchLandingPageWithRecords :: (?modelContext :: ModelContext) => Id LandingPage -> IO LandingPageWithRecords
fetchLandingPageWithRecords landingPageId = do

    landingPage <- fetch landingPageId

    paragraphCtas <- fetch landingPage.paragraphCtasRefLandingPages

    paragraphHeroImages <- fetch landingPage.paragraphHeroImages

    paragraphQuotes <- fetch landingPage.paragraphQuotes

    return $ LandingPageWithRecords { .. }

getParagraphsCount :: (?modelContext::ModelContext) => Id LandingPage -> IO Int
getParagraphsCount landingPageId = do
    landingPageWithRecords <- fetchLandingPageWithRecords landingPageId

    pure $ length landingPageWithRecords.paragraphCtas
                    + length landingPageWithRecords.paragraphHeroImages
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

setFormStatus :: (?context :: ControllerContext) => FormStatus -> IO ()
setFormStatus formStatus = setSession "formStatus" (show formStatus)

-- | Get the form status from the session and clear it.
getAndClearFormStatus :: (?context :: ControllerContext) => IO FormStatus
getAndClearFormStatus = do
    maybeFormStatus <- getSessionAndClear @Text "formStatus"
    pure $ case maybeFormStatus of
        Just "FormStatusSuccess" -> FormStatusSuccess
        Just "FormStatusError" -> FormStatusError
        _ -> FormStatusNotSubmitted