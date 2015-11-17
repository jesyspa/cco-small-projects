import CCO.Component  (Component, component, printer, ioWrap)
import CCO.Diag       (Diag)
import CCO.Tree       (Tree (fromTree, toTree), parser)
import Control.Arrow  (Arrow (arr), (>>>))

typecheckTDiag :: Component Diag Diag
typecheckTDiag = undefined

main = ioWrap (parser >>> component toTree >>> typecheckTDiag >>> arr fromTree >>> printer)
