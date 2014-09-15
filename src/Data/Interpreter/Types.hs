module Data.Interpreter.Types (
  TeletypeF(..),
  Teletype
) where

import Control.Monad.Free (Free)

data TeletypeF x
  = PutStrLn String x
  | GetLine (String -> x)
  | ExitSuccess

instance Functor TeletypeF where
  fmap f (PutStrLn str x) = PutStrLn str (f x)
  fmap f (GetLine k) = GetLine (f . k)
  fmap _ (ExitSuccess) = ExitSuccess

type Teletype = Free TeletypeF
