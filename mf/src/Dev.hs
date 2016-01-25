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

-- | Run the analysis in the given file.
run :: Analysis Program' a -> String -> IO ()
run anl name = parse' name >>= runAnalysis' anl

-- run some analysis by passing an analysis function and a 'show' function to display the result
runAnalysis' :: Analysis Program' a -> Program' -> IO ()
runAnalysis' (Analysis getSpec applyResult) p = do
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

-- | Parse a program in the examples directory.
--
-- Lookup is relative to this file.
parseExample :: String -> IO Program
parseExample programName = parse $ "../examples/"++programName++".c"

-- | Parse a program 
parse :: String -> IO Program
parse fileName = happy . alex <$> readFile fileName

-- | Parse and label a program.
parse' :: String -> IO Program'
parse' = fmap toLabelled . parse
