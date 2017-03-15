module Main where

import Data.Semigroup

import Options.Applicative

import Apple.Maclight

data MaclightOpts = MaclightOpts { backlight :: Light
                                 , lightCommand :: Command
                                 }

options :: Parser MaclightOpts
options = MaclightOpts
    <$> argument auto
        ( metavar "LIGHT"
       <> help "The backlight to control (one of 'keyboard' or 'screen')" )
    <*> argument auto
        ( metavar "CMD"
       <> help ( unlines ["What to do to the backlight ",
                          "(one of up, down, max, off, or set=n)"] ))

main :: IO ()
main = execParser parser >>= run
  where
    parser = info (helper <*> options)
              ( fullDesc
             <> progDesc "Control a Macbook's backlight"
             <> header "maclight - a Macbook backlight controller" )
    run opts = handleBacklight (backlight opts) (lightCommand opts)
