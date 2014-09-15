module Data.Interpreter.Actions (
  putStrLn',
  getLine',
  exitSuccess'
) where

import Control.Monad.Free (liftF)

import Data.Interpreter.Types

putStrLn' :: String -> Teletype ()
putStrLn' s = liftF $ PutStrLn s ()

getLine' :: Teletype String
getLine' = liftF $ GetLine id

exitSuccess' :: Teletype ()
exitSuccess' = liftF ExitSuccess