module Main where

import Test.Hspec
import IHP.Prelude
import IHP.FrameworkConfig
import IHP.Test.Mocking
import IHP.HaskellSupport
import IHP.ModelSupport
import Config

import Generated.Types
import Web.Routes
import Web.Types
import Web.FrontController
import Network.Wai
import IHP.ControllerPrelude
import IHP.ViewPrelude

main :: IO ()
main = hspec do
    tests

tests :: Spec
tests = aroundAll (withIHPApp WebApplication config) do
    describe "Test" do
        it "should work" $ withContext do
            True `shouldBe` True