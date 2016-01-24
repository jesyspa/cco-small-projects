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

stronglyLiveVariableAnalysis :: Program' -> AnalysisSpec (S.Set String)
stronglyLiveVariableAnalysis prog = AnalysisSpec { combine = S.union
                                                 , leq = S.isSubsetOf
                                                 , flowGraph = flowR stat
                                                 , entries = final stat
                                                 , A.labels = P.labels stat
                                                 , bottom = S.empty
                                                 , extremal = allNames
                                                 , update = update
                                                 , pp = ppF
                                                 }
    where update = Monolithic $ \x -> M.findWithDefault id x (sem_Program' prog)
          allNames = names prog
          Program' _ stat = prog

ppF :: S.Set String -> String
ppF s = "{" ++ intercalate ", " (S.elems s) ++ "}"
