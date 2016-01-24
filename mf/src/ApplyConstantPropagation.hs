module ApplyConstantPropagation (
      propagateConstants
) where

import AG.AttributeGrammar
import AG.ApplyConstantPropagation
import Analysis
import qualified Data.Map as M
import Data.Maybe

propagateConstants :: AnalysisResult (Maybe (M.Map String Int)) -> Program' -> Program'
propagateConstants result prog = sem_Program' prog (\i -> maybe M.empty id $ result i Entry)
