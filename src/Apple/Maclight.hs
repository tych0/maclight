module Apple.Maclight (
  screenBacklight,
  keyboardBacklight,
  Command(..),
  Settings(..),
  parseCommand,
  handleBacklight,
  ) where

import System.FilePath

import qualified System.IO.Strict as S

data Command = Up | Down | Max | Off

data Settings = Settings { sysPath :: FilePath
                         , stepCount :: Int
                         }

screenBacklight :: String
screenBacklight = "/sys/class/backlight/intel_backlight/"

keyboardBacklight :: String
keyboardBacklight = "/sys/class/leds/smc::kbd_backlight/"

parseCommand :: String -> Either Command String
parseCommand "up" = Left Up
parseCommand "down" = Left Down
parseCommand "off" = Left Off
parseCommand "max" = Left Max
parseCommand c = Right $ "Invalid command " ++ c

handleBacklight :: Settings -> Command -> IO ()
handleBacklight settings command = do
  let path = sysPath settings
      steps = stepCount settings
  maxB <- readInt $ path </> "max_brightness"
  current <- readInt $ path </> "brightness"
  let new = case command of
              Up -> min maxB (current + (maxB `div` steps))
              Down -> max 0 (current - (maxB `div` steps))
              Max -> maxB
              Off -> 0
  writeFile (path </> "brightness") (show new)
    where
      readInt :: FilePath -> IO Int
      readInt path = do
        str <- S.readFile path
        let [(v, _)] = reads str :: [(Int, String)]
        return v
