module Main where

import Control.Teletype
import Test.QuickCheck

-- chaining together actions
echoOnce :: TeletypeF ()
echoOnce = getLine' >>= putStrLn' >> exitSuccess' >> putStrLn' "no"

-- testing with a pure interpreter
prop_TakeOne :: IO ()
prop_TakeOne = quickCheck (\xs -> runPure echoOnce xs == take 1 xs)

main :: IO ()
main = prop_TakeOne
