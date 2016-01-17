module StronglyLiveVariable (
      stronglyLiveVariableAnalysis
) where

import AG.AttributeGrammar
import AG.StronglyLiveVariable
import Analysis as A
import qualified Data.Map as M
import qualified Data.Set as S
import Properties as P

stronglyLiveVariableAnalysis :: Program' -> AnalysisSpec (S.Set String)
stronglyLiveVariableAnalysis prog = AnalysisSpec { combine = S.union
                                                 , leq = S.isSubsetOf
                                                 , flowGraph = flowR stat
                                                 , entries = final stat
                                                 , A.labels = P.labels stat
                                                 , bottom = S.empty
                                                 , extremal = allNames
                                                 , update = update
                                                 }
    where update = Monolithic $ \x -> M.findWithDefault id x (sem_Program' prog)
          allNames = names prog
          Program' _ stat = prog
