import CCO.HM.Compiler  (compile)
import CCO.Component    (printer, ioWrap, component)
import CCO.Tree         (fromTree, toTree, parser)
import Control.Arrow    (arr, (>>>))

main = ioWrap $ parser >>> component toTree >>> compile >>> arr fromTree >>> printer
