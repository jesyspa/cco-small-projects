module Dev where

import qualified Data.Map as M
import qualified Data.List as L
import Control.Monad
import Control.Monad.Writer
import Text.PrettyPrint

import AG.AttributeGrammar
import Comment
import Parsing.Lexer
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

-- | Strongly live variable analysis specification
slv = Analysis stronglyLiveVariableAnalysis removeDeadAssignments

-- | Constant propagation analysis specification
cp  = Analysis constantPropagationAnalysis propagateConstants

-- | Run the analysis.
--
-- There being two names for this is a historical oddity.
run :: Analysis Program' a -> String -> IO ()
run = runAnalysis'

-- run some analysis by passing an analysis function and a 'show' function to display the result
runAnalysis' :: Analysis Program' a -> String -> IO ()
runAnalysis' (Analysis getSpec applyResult) programName = do
    p <- parse' programName

    putStrLn "Input Program:"
    putStrLn . render $ ppProgram' p
    let spec = getSpec p
        (result, msgs) = runWriter $ runInterprocAnalysis 5 spec
        ppS = pp spec

    putStr "\nFlowGraph: "
    print $ flowGraph spec
    putStr "Inter-procedural flow: "
    print $ procFlowGraph spec

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

-- | Parse a program.
parse :: String -> IO Program
parse programName = do
   let fileName = "../examples/"++programName++".c"
   happy . alex <$> readFile fileName

-- | Parse and label a program.
parse' :: String -> IO Program'
parse' = fmap toLabelled . parse
