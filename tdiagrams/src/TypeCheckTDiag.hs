import CCO.Component      (Component, component, printer, ioWrap)
import CCO.Diag           (Diag)
import CCO.Diag.TypeCheck (tcTDiag)
import CCO.Tree           (Tree (fromTree, toTree), parser)
import Control.Arrow      (Arrow (arr), (>>>))

main = ioWrap (parser >>> component toTree >>> tcTDiag >>> arr fromTree >>> printer)
