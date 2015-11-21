import CCO.Component  (Component, component, printer, ioWrap)
import CCO.Diag       (Diag, tcTDiag)
import CCO.Tree       (Tree (fromTree, toTree), parser)
import Control.Arrow  (Arrow (arr), (>>>))

main = ioWrap (parser >>> component toTree >>> tcTDiag >>> arr fromTree >>> printer)
