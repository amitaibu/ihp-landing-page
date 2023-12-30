module Web.Controller.Projects where

import Web.Controller.Prelude
import Web.View.Projects.Index
import Web.View.Projects.New
import qualified IHP.QueryBuilder as QueryBuilder


instance Controller ProjectsController where
    action ProjectsAction = do
        let values :: [(ProjectType, Int)] = [(ProjectTypeOngoing, 3), (ProjectTypeNotStarted, 2)]

            valuePairToCondition :: (ProjectType, Int) -> QueryBuilder "projects"
            valuePairToCondition (projectType, participants) =
                query @Project
                    |> filterWhere (#projectType, projectType)
                    |> filterWhere (#participants, participants)

            theQuery = buildOrQuery (map valuePairToCondition values)

        projects <- fetch theQuery
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

buildOrQuery :: [QueryBuilder "projects"] -> NoJoinQueryBuilderWrapper "projects"
buildOrQuery (query:rest) = queryUnion query (buildOrQuery rest)
buildOrQuery [] =
    let
        inner =
            query @Project
            |> filterWhereSql (#id, "IS NULL") -- Always false condition
    in
        queryUnion inner inner -- Terrible hack to make the types work out