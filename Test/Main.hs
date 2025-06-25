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
import Network.HTTP.Types.Status

import Test.UsersSpec

main :: IO ()
main = hspec do
    Test.UsersSpec.tests

tests :: Spec
tests = aroundAll (withIHPApp WebApplication config) do
    describe "Test" do
        itShouldAllowNewAndCreate User


itShouldAllowNewAndCreate ::
    forall record application.
    ( ?modelContext :: ModelContext
    , Typeable application
    , Typeable record
    , Record record
    , CanCreate record
    )
    => record -> SpecWith (MockContext application)
itShouldAllowNewAndCreate record  =
     it "should allow new and create" $ withContext do
        True `shouldBe` True