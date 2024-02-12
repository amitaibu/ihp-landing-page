module Config where

import IHP.Prelude
import IHP.Environment
import IHP.FileStorage.Config
import IHP.FrameworkConfig ( ConfigBuilder, option )
import Web.View.CustomCSSFramework
import "cryptonite" Crypto.PubKey.RSA as RSA
import Control.Exception (catch)
import qualified Data.ByteString as BS
import Web.JWT
import IHP.EnvVar

data RsaKeys = RsaKeys { publicKey :: RSA.PublicKey, privateKey :: RSA.PrivateKey }

config :: ConfigBuilder
config = do
    -- See https://ihp.digitallyinduced.com/Guide/config.html
    -- for what you can do here
    option customTailwind

    -- Static directory.
    initStaticDirStorage

    jwtPrivateKeyPath <- envOrDefault "JWT_PRIVATE_KEY_PATH" "./Config/jwtRS256.key"
    jwtPublicKeyPath <- envOrDefault "JWT_PUBLIC_KEY_PATH" "./Config/jwtRS256.key"

    -- Private and public keys to sign and verify image style URLs.
    privateKeyContent <- liftIO $ readRsaKeyFromFile jwtPrivateKeyPath
    publicKeyContent <- liftIO $ readRsaKeyFromFile jwtPublicKeyPath

    case (readRsaSecret privateKeyContent, readRsaPublicKey publicKeyContent) of
        (Just privateKey, Just publicKey) -> option $ RsaKeys publicKey privateKey
        _ -> error "Failed to read RSA keys, please execute from the root of your project: ssh-keygen -t rsa -b 4096 -m PEM -f ./Config/jwtRS256.key && openssl rsa -in ./Config/jwtRS256.key -pubout -outform PEM -out ./Config/jwtRS256.key.pub"


readRsaKeyFromFile :: FilePath -> IO BS.ByteString
readRsaKeyFromFile path = do
    catch (BS.readFile path) handleException
  where
    handleException :: IOError -> IO BS.ByteString
    handleException _ = return BS.empty