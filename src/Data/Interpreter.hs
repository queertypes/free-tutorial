module Data.Interpreter (
  run,
  runPure
) where

import Control.Monad.Free
import System.Exit hiding (ExitSuccess)

-- Notice how the interpreters exist independently of the specific
-- actions. Notably, importing Data.Interpreter.Actions is redundant.
import Data.Interpreter.Types

run :: Teletype r -> IO r
run (Pure r) = return r
run (Free (PutStrLn str x)) = putStrLn str >> run x
run (Free (GetLine t)) = getLine >>= run . t
run (Free ExitSuccess) = exitSuccess

runPure :: Teletype r -> [String] -> [String]
runPure (Pure _) _ = []
runPure (Free (PutStrLn y t)) xs = y : runPure t xs
runPure (Free (GetLine _)) [] = []
runPure (Free (GetLine k)) (x:xs) = runPure (k x) xs
runPure (Free ExitSuccess) _ = []
