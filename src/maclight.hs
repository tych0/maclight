module Main where

import Options.Applicative

import Apple.Maclight

data MaclightOpts = MaclightOpts { backlight :: String
                                 , lightCommand :: String
                                 }

options :: Parser MaclightOpts
options = MaclightOpts
    <$> argument str
        ( metavar "LIGHT"
       <> help "The backlight to control (one of 'keyboard' or 'screen')" )
    <*> argument str
        ( metavar "CMD"
       <> help "What to do to the backlight (one of up, down, max, or off)" )

main :: IO ()
main = execParser opts >>= run
  where
    opts = info (helper <*> options)
      ( fullDesc
     <> progDesc "Control a Macbook's backlight"
     <> header "maclight - a Macbook backlight controller" )
    run cliOpts =
      let cmd = case parseCommand $ lightCommand cliOpts of
                  Left a -> a
                  -- TODO: handle this better
                  Right _ -> Off
          path = case backlight cliOpts of
                   "keyboard" -> keyboardBacklight
                   "screen" -> screenBacklight
                   -- TODO: handle this better
                   _ -> keyboardBacklight
          settings = Settings path 16
      in handleBacklight settings cmd
