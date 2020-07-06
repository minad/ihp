module IHP.IDE.ToolServer.ViewContext where

import IHP.Prelude
import qualified IHP.Controller.Session as Session
import IHP.ControllerSupport  (RequestContext (RequestContext))
import IHP.ControllerSupport
import IHP.HaskellSupport
import IHP.ModelSupport
import qualified IHP.ViewSupport as ViewSupport
import IHP.IDE.ToolServer.Types
import IHP.IDE.ToolServer.Layout
import IHP.IDE.Types
import IHP.IDE.ToolServer.Helper.Controller
import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import System.Directory

instance ViewSupport.CreateViewContext ViewContext where
    type ViewApp ViewContext = ToolServerApplication
    createViewContext = do
        flashMessages <- Session.getAndClearFlashMessages
        listOfWebControllers' <- listOfWebControllers

        let viewContext = ViewContext {
                requestContext = ?requestContext,
                flashMessages,
                controllerContext = ?controllerContext,
                layout = let ?viewContext = viewContext in toolServerLayout,
                appUrl = "http://localhost:" <> tshow appPort,
                webControllers = listOfWebControllers'
            }
        pure viewContext


listOfWebControllers :: IO [Text]
listOfWebControllers = do
    directoryFiles <-  listDirectory "Web/Controller"
    let controllerFiles :: [Text] =  filter (\x -> not $ "Prelude" `isInfixOf` x || "Context" `isInfixOf` x)  $ map cs directoryFiles
    pure $ map (Text.replace ".hs" "") controllerFiles
