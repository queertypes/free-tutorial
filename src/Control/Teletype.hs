{-# LANGUAGE FlexibleContexts, DeriveFunctor #-}
--------------------------------------------------------------------------------
-- It's no secret - Allele Dev enjoys writing Haskell
--
-- This is a tiny example of using Free monads + improve.
--------------------------------------------------------------------------------
module Control.Teletype where

import Control.Monad
import Control.Monad.Free
import qualified Control.Monad.Free.Church as C
import System.Exit hiding (ExitSuccess)


--------------------------------------------------------------------------------
--                      Define Your Free Type                                 --
--------------------------------------------------------------------------------
data Teletype x
  = PutStrLn String x
  | GetLine (String -> x)
  | ExitSuccess
    deriving Functor

type TeletypeF = Free Teletype

-- the MonadFree encoding here and below is crucial
-- A more specific type signature,
--   TeletypeF a -> m ()
-- Prevents us from leveraging improve later
-- MonadFree keeps the internal representation flexible up to the last minute.
putStrLn' :: MonadFree Teletype m => String -> m ()
putStrLn' s = liftF $ PutStrLn s ()

getLine' ::  MonadFree Teletype m => m String
getLine' = liftF $ GetLine id

exitSuccess' :: MonadFree Teletype m => m ()
exitSuccess' = liftF ExitSuccess

--------------------------------------------------------------------------------
--                     Define Some Interpreters                               --
--------------------------------------------------------------------------------
run :: TeletypeF a -> IO a
run = iterM go
  where go (PutStrLn x1 x2) = putStrLn x1 >> x2
        go (GetLine x) = getLine >>= x
        go ExitSuccess = exitSuccess

runPure :: TeletypeF a -> [String] -> [String]
runPure (Pure _) _ = []
runPure (Free (PutStrLn y t)) xs = y : runPure t xs
runPure (Free (GetLine k)) (x:xs) = runPure (k x) xs
runPure (Free (GetLine _)) [] = []
runPure (Free ExitSuccess) _ = []

--------------------------------------------------------------------------------
--                     Write a Teletype Program                               --
--      (Or Ten. Write Your App's Core Logic in Terms of Free)                --
--------------------------------------------------------------------------------
echo :: MonadFree Teletype m => m ()
echo = do
  c <- getLine'
  when (c /= "") $ do
    putStrLn' c
    echo

--------------------------------------------------------------------------------
--           Hook Into Your Main Processing Sequence/Loop                     --
--------------------------------------------------------------------------------
mkMain :: TeletypeF a -> IO ()
mkMain f = print $ runPure f (replicate 100000 "cat")

-- for this particular example, improve doesn't do much
-- > :set +s
-- > mainImproved
-- ...
-- (1.01 secs, 578,622,000 bytes)
-- > main'
-- ...
-- (1.00 secs, 555,225,208 bytes)
--
-- see this talk by raichoo for a case where improve makes a
--   *big* difference*
-- Link: https://vimeo.com/146374255
mainImproved :: IO ()
mainImproved = mkMain (C.improve echo)

main' :: IO ()
main' = mkMain echo
