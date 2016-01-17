module ApplyConstantPropagation (
      propagateConstants
) where

import AG.AttributeGrammar
import AG.ApplyConstantPropagation
import Analysis
import qualified Data.Map as M

propagateConstants :: AnalysisResult (M.Map String Int) -> Program' -> Program'
propagateConstants result prog = sem_Program' prog (\i -> result i Entry)
