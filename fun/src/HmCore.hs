import CCO.HM.Compiler  (compile)
import CheapPrinter     (cheapPrinter)
import CCO.Component    (ioWrap, component)
import CCO.Tree         (fromTree, toTree, parser)
import Control.Arrow    (arr, (>>>))
import System.Environment

-- We don't use the built-in printer mechanism because it is ridiculously slow.
main = do
    args <- getArgs
    ioWrap $ parser >>> component toTree >>> compile >>> arr fromTree >>> cheapPrinter ("-p" `elem` args)
