import Control.Concurrent.STM.TVar (TVar, newTVarIO, modifyTVar', readTVarIO)
import Control.Monad (msum)
import Control.Monad.IO.Class (liftIO)
import Control.Monad.STM (atomically)
import Data.Map.Strict (Map, empty, findWithDefault, insert)
import Happstack.Server (BodyPolicy, ServerPartT, decodeBody, defaultBodyPolicy, look, nullConf, simpleHTTP, ok, dir)

type KeyValue = Map String String

main :: IO ()
main = do
    keyValueRef <- newTVarIO (empty :: KeyValue)
    simpleHTTP nullConf $ do
        decodeBody decodePolicy
        msum [ get keyValueRef, set keyValueRef ]

decodePolicy :: BodyPolicy
decodePolicy = defaultBodyPolicy "/tmp/" 0 1000 1000

set :: TVar KeyValue -> ServerPartT IO String
set keyValueRef = dir "set" $ do
        key <- look "key"
        value <- look "value"
        liftIO $ atomically $ modifyTVar' keyValueRef (insert key value)
        ok ("SET " ++ key ++ ": " ++ value ++ "\n")

get :: TVar KeyValue -> ServerPartT IO String
get keyValueRef = dir "get" $ do
        key <- look "key"
        keyValue <- liftIO $ readTVarIO keyValueRef
        let value = findWithDefault "" key keyValue
        ok value