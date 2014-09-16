module Main where

import Criterion.Main

import Data.Interpreter.Actions
import Data.Interpreter.Types
import Data.Interpreter

main :: IO ()
main = defaultMain
  [ bench "echo_engine" $ nf (runPure echo) ["cat", "dog"]
  ]

echo :: Teletype ()
echo = getLine' >>= putStrLn' >> exitSuccess' >> putStrLn' "Finished"