{-# LANGUAGE OverloadedStrings #-}
module Main
    ( main
    ) where

import           Control.Concurrent   (forkIO)
import           Control.Monad       (forever, unless)
import           Control.Monad.Trans (liftIO)
import           Network.Socket      (withSocketsDo)
import           Data.Text           (Text)
import qualified Data.Text           as T
import qualified Data.Text.IO        as T
import qualified Network.WebSockets  as WS

respondToClient :: WS.Connection -> IO ()
respondToClient conn = do
    _ <- forkIO $ forever $ do
        msg <- WS.receiveData conn
        liftIO $ T.putStrLn msg

    let loop = do
            let line = "Bye from Haskell!" :: Text
            WS.sendTextData conn line >> loop
    loop

testServer :: IO ()
testServer = do
  putStrLn "starting server..."
  WS.runServer "127.0.0.1" 3333 $ \pending -> do
    conn <- WS.acceptRequest pending
    respondToClient conn
    WS.sendClose conn ("" :: Text)


main :: IO ()
main = testServer
