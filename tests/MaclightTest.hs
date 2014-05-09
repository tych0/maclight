module Main (main) where

import Test.Framework
import Test.Framework.Providers.HUnit
import Test.HUnit hiding (Test)

import Apple.Maclight

commandReadTests :: [(String, Command)]
commandReadTests = [ ("up", Up)
                   , ("down", Down)
                   , ("max", Max)
                   , ("off", Off)
                   , ("set=1", Set 1)
                   ]

makeCommandReadTest :: (String, Command) -> Test
makeCommandReadTest (inp, expected) =
  testCase inp (assertEqual inp expected (read inp))

main :: IO()
main = defaultMain (map makeCommandReadTest commandReadTests)
