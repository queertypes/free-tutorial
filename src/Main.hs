module Main (
  main
) where

import Data.Interpreter.Actions
import Data.Interpreter.Types
import Data.Interpreter

echo :: Teletype ()
echo = getLine' >>= putStrLn' >> exitSuccess' >> putStrLn' "Finished"

main :: IO ()
main = print $ runPure echo ["cat", "dog"]