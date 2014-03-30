{-# LANGUAGE ViewPatterns #-}
module Apple.Maclight (
  getDirectory,
  Light(..),
  Command(..),
  Settings(..),
  handleBacklight,
  ) where

import System.FilePath

import qualified System.IO.Strict as S

data Command = Up | Down | Max | Off | Set Int

readMay :: String -> Maybe Int
readMay i = case reads i of
              [(n, "")] -> Just n
              _ -> Nothing

instance Read Command where
  readsPrec _ s = case s of
                    "up" -> [(Up, "")]
                    "down" -> [(Down, "")]
                    "max" -> [(Max, "")]
                    "off" -> [(Off, "")]
                    's':'e':'t':'=' : (readMay -> Just i) -> [(Set i, "")]
                    _ -> []

data Light = Screen | Keyboard

instance Read Light where
  readsPrec _ s = case s of
                    "screen" -> [(Screen, "")]
                    "keyboard" -> [(Keyboard, "")]
                    _ -> []

data Settings = Settings { sysPath :: FilePath
                         , stepCount :: Int
                         }

getDirectory :: Light -> FilePath
getDirectory Screen = "/sys/class/backlight/intel_backlight/"
getDirectory Keyboard = "/sys/class/leds/smc::kbd_backlight/"

handleBacklight :: Light -> Command -> IO ()
handleBacklight light command = do
  let path = getDirectory light
  maxB <- readInt $ path </> "max_brightness"
  current <- readInt $ path </> "brightness"
  let new = case command of
              Up -> min maxB (current + (maxB `div` 16))
              Down -> max 0 (current - (maxB `div` 16))
              Max -> maxB
              Off -> 0
              Set i -> i
  writeFile (path </> "brightness") (show new)
    where
      readInt :: FilePath -> IO Int
      readInt path = do
        str <- S.readFile path
        let [(v, _)] = reads str :: [(Int, String)]
        return v
