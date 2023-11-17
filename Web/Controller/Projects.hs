module Web.Controller.Projects where

import Web.Controller.Prelude
import Web.View.Projects.Index
import Web.View.Projects.New
import Database.PostgreSQL.Simple.ToField
import Data.ByteString.Builder (byteString, char8)


instance ToField (ProjectType, Int) where
    toField = serializeTuple


serializeTuple :: (ProjectType, Int) -> Action
serializeTuple (projectType, participants) = Many
    [ Plain (byteString "(")
    , toField projectType
    , Plain (char8 ',')
    , toField $ show participants
    , Plain (char8 ')')
    ]

instance Controller ProjectsController where
    action ProjectsAction = do
        projects <- query @Project |> fetch


        -- let pairs = projects |> fmap (\project -> (project.projectType, project.participants))
        let pairs = [(ProjectTypeOngoing, 1 :: Int), (ProjectTypeFinished, 2)]

        -- Use a parameterized query to handle list of tuples
        projectsQuery :: [Project] <- sqlQuery "SELECT * FROM projects WHERE (project_type, participants) IN ?" (Only $ In pairs)


        render IndexView { .. }

    action NewProjectAction = do
        let project = newRecord
        render NewView { .. }

    action CreateProjectAction = do
        let project = newRecord @Project
        project
            |> buildProject
            |> ifValid \case
                Left project -> render NewView { .. }
                Right project -> do
                    project <- project |> createRecord
                    setSuccessMessage "Project created"
                    redirectTo ProjectsAction

buildProject project = project
    |> fill @'["projectType", "participants"]
