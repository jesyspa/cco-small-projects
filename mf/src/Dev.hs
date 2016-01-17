module Dev where

import qualified Data.Map as M
import qualified Data.List as L

import AG.AttributeGrammar
import Parsing.Lexer
import Main
import Parsing.Parser
import PrettyPrint
import Labelling
import ConstantPropagation
import ApplyConstantPropagation
import Analysis

{-- How To Run (examples)

-- Strongly Live Variables
ghci> run slv "fib"

--}

slv = undefined
cp  = Analysis constantPropagationAnalysis propagateConstants

run :: (Eq a, Show a) => Analysis Program' a -> String -> IO ()
run = runAnalysis'

-- run some analysis by passing an analysis function and a 'show' function to display the result
runAnalysis' :: (Eq a, Show a) => Analysis Program' a -> String -> IO ()
runAnalysis' (Analysis getSpec applyResult) programName = do
  p <- parse programName
  putStrLn "OUTPUT:"
  -- The "analysis" by itself isn't what we want to print; it's just rules for making the analysis
  -- We actually want to analyse using runAnalysis and then print the annotated results.
  print p
  let spec = getSpec p
      result = chaoticIteration p spec
  print $ applyResult result p
  putStrLn "G'bye"

-- parse program

parse :: String -> IO Program
parse programName = do
  let fileName = "../examples/"++programName++".c"
  happy . alex <$> readFile fileName

parse' :: String -> IO Program'
parse' = fmap toLabelled . parse

