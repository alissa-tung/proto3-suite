{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE DeriveGeneric       #-}
{-# LANGUAGE FlexibleInstances   #-}
{-# LANGUAGE LambdaCase          #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE RecordWildCards     #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE StandaloneDeriving  #-}
{-# LANGUAGE TypeOperators       #-}

import           Data.Semigroup                 ((<>))
import           Options.Applicative
import           Prelude                        hiding (FilePath)
import           Proto3.Suite.DotProto.Generate

parseArgs :: ParserInfo CompileArgs
parseArgs = info parser (fullDesc <> progDesc "Compiles a .proto file to a Haskell module")
  where
    parser = CompileArgs <$> includes <*> extraInstances <*> proto <*> out <*> disableUnwrapping

    includes = many $ strOption $
      long "includeDir"
        <> metavar "DIR"
        <> help "Path to search for included .proto files (can be repeated, and paths will be searched in order; the current directory is used if this option is not provided)"

    extraInstances = many $ strOption $
      long "extraInstanceFile"
        <> metavar "DIR"
        <> help "Additional file to provide instances that would otherwise be generated. Can be used multiple times. Types for which instance overrides are given must be fully qualified."

    proto = strOption $
      long "proto"
        <> metavar "FILE"
        <> help "Path to input .proto file"

    out = strOption $
      long "out"
        <> metavar "FILE"
        <> help "Output directory path where generated Haskell modules will be written (directory is created if it does not exist; note that files in the output directory may be overwritten!)"

    disableUnwrapping = switch $
      long "disableUnwrapping"
        <> help "Disables the unwrapping of `*Value` Wrapper types in the Haskell type and JSON representation"


main :: IO ()
main = execParser parseArgs >>= compileDotProtoFileOrDie
