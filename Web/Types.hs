module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types
import IHP.LoginSupport.Types
import IHP.View.Form


-- Custom types

{-| The result of fetching Landing page with all its paragraphs.

@see `fetchLandingPageWithRecords`
-}
data LandingPageWithRecords = LandingPageWithRecords
    { landingPage :: !LandingPage
    , paragraphCtas :: ![ParagraphCta]
    , paragraphQuotes :: ![ParagraphQuote]
    , paragraphHeroImages :: ![ParagraphHeroImage]
    } deriving (Show)

{-| With the `FormStatus` we can show a message to the user after submitting a form,
indicating if the form was successful or not.
-}
data FormStatus
    = FormStatusNotSubmitted
    | FormStatusSuccess
    | FormStatusError deriving (Eq, Show)

-- Instances

instance CanSelect LandingPage where
    type SelectValue LandingPage = Id LandingPage
    selectValue landingPage = landingPage.id
    selectLabel landingPage = landingPage.title

--

data WebApplication = WebApplication deriving (Eq, Show)

data LandingPagesController
    = LandingPagesAction
    | NewLandingPageAction
    | ShowLandingPageAction { landingPageId :: !(Id LandingPage) }
    | CreateLandingPageAction
    | EditLandingPageAction { landingPageId :: !(Id LandingPage) }
    | UpdateLandingPageAction { landingPageId :: !(Id LandingPage) }
    | DeleteLandingPageAction { landingPageId :: !(Id LandingPage) }
    deriving (Eq, Show, Data)

data ParagraphCtasController
    = NewParagraphCtaAction { landingPageId :: !(Id LandingPage) }
    | CreateParagraphCtaAction
    | EditParagraphCtaAction { paragraphCtaId :: !(Id ParagraphCta) }
    | UpdateParagraphCtaAction { paragraphCtaId :: !(Id ParagraphCta) }
    | DeleteParagraphCtaAction { paragraphCtaId :: !(Id ParagraphCta) }
    deriving (Eq, Show, Data)

data ParagraphQuotesController
    = NewParagraphQuoteAction { landingPageId :: !(Id LandingPage) }
    | CreateParagraphQuoteAction
    | EditParagraphQuoteAction { paragraphQuoteId :: !(Id ParagraphQuote) }
    | UpdateParagraphQuoteAction { paragraphQuoteId :: !(Id ParagraphQuote) }
    | DeleteParagraphQuoteAction { paragraphQuoteId :: !(Id ParagraphQuote) }
    deriving (Eq, Show, Data)

data ParagraphHeroImagesController
    = NewParagraphHeroImageAction { landingPageId :: !(Id LandingPage) }
    | CreateParagraphHeroImageAction
    | EditParagraphHeroImageAction { paragraphHeroImageId :: !(Id ParagraphHeroImage) }
    | UpdateParagraphHeroImageAction { paragraphHeroImageId :: !(Id ParagraphHeroImage) }
    | DeleteParagraphHeroImageAction { paragraphHeroImageId :: !(Id ParagraphHeroImage) }
    deriving (Eq, Show, Data)



data ImageStyleController
    = RenderImageStyleAction { width :: !Int, height :: !Int, originalImagePath :: !Text, signed :: !Text }
    deriving (Eq, Show, Data)

instance HasNewSessionUrl User where
    newSessionUrl _ = "/NewSession"

type instance CurrentUserRecord = User

data SessionsController
    = NewSessionAction
    | CreateSessionAction
    | DeleteSessionAction
    deriving (Eq, Show, Data)
data UsersController
    = UsersAction
    | NewUserAction
    | ShowUserAction { userId :: !(Id User) }
    | CreateUserAction
    | EditUserAction { userId :: !(Id User) }
    | UpdateUserAction { userId :: !(Id User) }
    | DeleteUserAction { userId :: !(Id User) }
    deriving (Eq, Show, Data)

data StyleGuideController
    = StyleGuideAction
    deriving (Eq, Show, Data)
