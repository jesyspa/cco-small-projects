module ApplyConstantPropagation (
      propagateConstants
) where

import AG.AttributeGrammar
import AG.ApplyConstantPropagation
import Analysis
import qualified Data.Map as M

propagateConstants :: AnalysisResult (M.Map String Int) -> Stat' -> Stat'
propagateConstants result stat = code_Syn_Stat' $ wrap_Stat' (sem_Stat' stat) (Inh_Stat' result)
