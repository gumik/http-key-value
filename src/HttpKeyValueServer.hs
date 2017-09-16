import Control.Monad (MonadPlus, msum)
import Happstack.Server (FilterMonad, Response, Method(GET, POST), ServerMonad, method, nullConf, simpleHTTP, toResponse, ok, dir, path)

main :: IO ()
main = simpleHTTP nullConf $ msum [ dir "set" $ (method POST >> (path $ \p -> ok ("You want to POST set key: " ++ p ++ "\n")))
                                  , dir "get" $ (method GET  >> (path $ \p -> ok ("You want to get key: " ++ p ++ "\n"))) ]
