import Control.Monad (MonadPlus, msum)
import Happstack.Server (BodyPolicy, FilterMonad, Response, Method(GET, POST), ServerMonad,
                         decodeBody, defaultBodyPolicy, look, method, methodM, nullConf, simpleHTTP, toResponse, ok, dir, path)

main :: IO ()
main = simpleHTTP nullConf $ do
    decodeBody decodePolicy
    msum [ get, set ]

decodePolicy :: BodyPolicy
decodePolicy = (defaultBodyPolicy "/tmp/" 0 1000 1000)

set = dir "set" $ do
    method POST
    path $ \p -> do
        value <- look "value"
        ok ("You want to set key: " ++ p ++ ", with value: " ++ value ++ "\n")

get = dir "get" $ (method GET  >> (path $ \p -> ok ("You want to get key: " ++ p ++ "\n")))