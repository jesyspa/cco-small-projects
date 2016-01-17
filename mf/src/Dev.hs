module Dev where

import qualified Data.Map as M
import qualified Data.List as L
import Control.Monad
import Text.PrettyPrint

import AG.AttributeGrammar
import Parsing.Lexer
import Main
import Parsing.Parser
import Properties as P
import PrettyPrint
import Labelling
import ConstantPropagation
import ApplyConstantPropagation
import StronglyLiveVariable
import Analysis
import ChaoticIteration

slv = Analysis stronglyLiveVariableAnalysis (const id)
cp  = Analysis constantPropagationAnalysis propagateConstants

run :: (Eq a, Show a) => Analysis Program' a -> String -> IO ()
run = runAnalysis'

-- run some analysis by passing an analysis function and a 'show' function to display the result
runAnalysis' :: (Eq a, Show a) => Analysis Program' a -> String -> IO ()
runAnalysis' (Analysis getSpec applyResult) programName = do
    p <- parse' programName
    putStrLn "OUTPUT:"
    -- The "analysis" by itself isn't what we want to print; it's just rules for making the analysis
    -- We actually want to analyse using runAnalysis and then print the annotated results.
    putStrLn . render $ ppProgram' p
    let result = chaoticIteration (getSpec p)
        Program' _ stat = p

    forM_ (P.labels stat) $ \l ->
        forM_ [Entry, Exit] $ \e -> do
            putStr $ show l
            putStr " ("
            putStr $ show e
            putStr "): "
            print $ result l e

    putStrLn . render . ppProgram' $ applyResult result p
    putStrLn "G'bye"

-- parse program

parse :: String -> IO Program
parse programName = do
   let fileName = "../examples/"++programName++".c"
   happy . alex <$> readFile fileName

parse' :: String -> IO Program'
parse' = fmap toLabelled . parse
