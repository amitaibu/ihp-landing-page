module Web.FrontController where

import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)


-- Controller Imports
import Web.Controller.StyleGuide
import Web.Controller.Users
import Web.Controller.ImageStyle
import Web.Controller.LandingPages
import Web.Controller.ParagraphCtas
import Web.Controller.ParagraphQuotes
import Web.Controller.ParagraphHeroImages

import IHP.LoginSupport.Middleware
import Web.Controller.Sessions

instance FrontController WebApplication where
    controllers =
        [ startPage LandingPagesAction
        -- Generator Marker
        , parseRoute @StyleGuideController
        , parseRoute @UsersController
        , parseRoute @ImageStyleController
        , parseRoute @LandingPagesController
        , parseRoute @ParagraphCtasController
        , parseRoute @ParagraphQuotesController
        , parseRoute @ParagraphHeroImagesController
        , parseRoute @SessionsController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        currentTime <- getCurrentTime
        setLayout (defaultLayout currentTime)
        initAutoRefresh
        initAuthentication @User
