module StronglyLiveVariable (
      stronglyLiveVariableAnalysis
) where

import AG.AttributeGrammar
import AG.StronglyLiveVariable
import Analysis as A
import qualified Data.Map as M
import qualified Data.Set as S
import Properties as P
import Data.List
import Text.PrettyPrint

-- | Specification for the SLV analysis.
--
-- Works exactly as described in the book; nothing interesting here.
stronglyLiveVariableAnalysis :: Program' -> AnalysisSpec SLVData
stronglyLiveVariableAnalysis prog = AnalysisSpec { combine = S.union
                                                 , leq = S.isSubsetOf
                                                 , flowGraph = flowR prog
                                                 , procFlowGraph = interFlow prog
                                                 , procBodies = bodies prog
                                                 , entries = final prog
                                                 , A.labels = P.labels prog
                                                 , bottom = S.empty
                                                 , extremal = allNames
                                                 , update = update
                                                 , pp = ppF
                                                 }
    where update = Monolithic $ \x -> M.findWithDefault id x (sem_Program' prog)
          allNames = names prog

-- | Pretty-print a set.
--
-- fromList ["a", "b", "c"] becomes {a, b, c}.
ppF :: S.Set String -> Doc
ppF = braces . hsep . punctuate comma . map text . S.elems
