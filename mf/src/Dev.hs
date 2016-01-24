module Dev where

import qualified Data.Map as M
import qualified Data.List as L
import Control.Monad
import Control.Monad.Writer
import Text.PrettyPrint

import AG.AttributeGrammar
import Comment
import Parsing.Lexer
import Main
import Parsing.Parser
import Properties as P
import PrettyPrint
import Labelling
import ConstantPropagation
import ApplyConstantPropagation
import StronglyLiveVariable
import ApplyStronglyLiveVariable
import Analysis
import IntraproceduralMFP
import InterproceduralMFP

slv = Analysis stronglyLiveVariableAnalysis removeDeadAssignments
cp  = Analysis constantPropagationAnalysis propagateConstants

run :: (Eq a, Show a) => Analysis Program' a -> String -> IO ()
run = runAnalysis'

-- run some analysis by passing an analysis function and a 'show' function to display the result
runAnalysis' :: (Eq a, Show a) => Analysis Program' a -> String -> IO ()
runAnalysis' (Analysis getSpec applyResult) programName = do
    p <- parse' programName

    putStrLn "Input Program:"
    putStrLn . render $ ppProgram' p
    let spec = getSpec p
        (result, msgs) = runWriter $ runInterprocAnalysis spec
        ppS = pp spec

    putStr "\nFlowGraph: "
    print $ flowGraph spec

    putStrLn "\nAnalysis progress:"
    putStrLn . render . vcat . map (ppComment ppS) $ msgs

    putStrLn "\nAnalysis results:"
    forM_ (P.labels p) $ \l -> do
        putStr $ show l
        putStr ": "
        putStr . render . ppS $ result l Entry
        putStr " -> "
        putStrLn . render . ppS $ result l Exit

    putStrLn "\nImproved program:"
    putStrLn . render . ppProgram' $ applyResult result p

-- parse program

parse :: String -> IO Program
parse programName = do
   let fileName = "../examples/"++programName++".c"
   happy . alex <$> readFile fileName

parse' :: String -> IO Program'
parse' = fmap toLabelled . parse
