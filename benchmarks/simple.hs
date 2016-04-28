module Main where

import Criterion.Main
import Control.Monad.Free.Church (improve)

import Control.Teletype

main :: IO ()
main = defaultMain
  [ bench "echo" $ nf (runPure echo) ["cat", "dog"]
  , bench "echo-improve" $ nf (runPure (improve echo)) ["cat", "dog"]
  ]
