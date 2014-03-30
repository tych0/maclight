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
  let result = case read inp of
                 [(cmd, "")] -> (Right cmd) :: Either String Command
                 _ -> Left $ "failed parsing: " ++ inp
  in testCase inp (assertEqual inp (Right expected) result)

main :: IO()
main = defaultMain (map makeCommandReadTest commandReadTests)
