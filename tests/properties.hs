module Main where

import Data.Interpreter.Types
import Data.Interpreter.Actions
import Data.Interpreter
import Test.QuickCheck

-- chaining together actions
echo :: Teletype ()
echo = getLine' >>= putStrLn' >> exitSuccess' >> putStrLn' "no"

-- testing with a pure interpreter
prop_TakeOne :: IO ()
prop_TakeOne = quickCheck (\xs -> runPure echo xs == take 1 xs)

main :: IO ()
main = prop_TakeOne