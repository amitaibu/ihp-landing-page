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
    , paragraphCtaRefLandingPages :: ![LandingPage]
    } deriving (Show)

--

data WebApplication = WebApplication deriving (Eq, Show)

data ParagraphQuotesController
    = ParagraphQuotesAction
    | NewParagraphQuoteAction { landingPageId :: !(Id LandingPage) }
    | ShowParagraphQuoteAction { paragraphQuoteId :: !(Id ParagraphQuote) }
    | CreateParagraphQuoteAction
    | EditParagraphQuoteAction { paragraphQuoteId :: !(Id ParagraphQuote) }
    | UpdateParagraphQuoteAction { paragraphQuoteId :: !(Id ParagraphQuote) }
    | DeleteParagraphQuoteAction { paragraphQuoteId :: !(Id ParagraphQuote) }
    deriving (Eq, Show, Data)

data ParagraphCtasController
    = ParagraphCtaAction
    | NewParagraphCtaAction { landingPageId :: !(Id LandingPage) }
    | ShowParagraphCtaAction { paragraphCtaId :: !(Id ParagraphCta) }
    | CreateParagraphCtaAction
    | EditParagraphCtaAction { paragraphCtaId :: !(Id ParagraphCta) }
    | UpdateParagraphCtaAction { paragraphCtaId :: !(Id ParagraphCta) }
    | DeleteParagraphCtaAction { paragraphCtaId :: !(Id ParagraphCta) }
    deriving (Eq, Show, Data)

data LandingPagesController
    = LandingPagesAction
    | NewLandingPageAction
    | ShowLandingPageAction { landingPageId :: !(Id LandingPage) }
    | CreateLandingPageAction
    | EditLandingPageAction { landingPageId :: !(Id LandingPage) }
    | UpdateLandingPageAction { landingPageId :: !(Id LandingPage) }
    | DeleteLandingPageAction { landingPageId :: !(Id LandingPage) }
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

data ProjectsController
    = ProjectsAction
    | NewProjectAction
    | CreateProjectAction
    deriving (Eq, Show, Data)

instance CanSelect ProjectType where
    type SelectValue ProjectType = ProjectType
    selectValue value = value
    selectLabel value = case value of
        ProjectTypeNotStarted -> "Not started"
        ProjectTypeOngoing -> "Ongoing"
        ProjectTypeFinished -> "Finished"