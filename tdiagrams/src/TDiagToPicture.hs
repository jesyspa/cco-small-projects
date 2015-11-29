import CCO.Component  (Component, component, printer, ioWrap)
import CCO.Tree       (Tree (fromTree, toTree), parser)
import CCO.Diag       (Diag)
import CCO.Picture    (Picture(..))
import Control.Arrow  (Arrow (arr), (>>>))
import CCO.Diag.AG.MakePicture
import CCO.Diag.Figure ((|-|), toPair)

tdiag2picture :: Component Diag Picture
tdiag2picture = arr $ \x ->
    let
      tree = wrap_Diag (sem_Diag x) $ Inh_Diag
      code = code_Syn_Diag tree
      blp = blp_Syn_Diag tree
      trp = trp_Syn_Diag tree
      offset = blp |-| trp

    in Picture (toPair offset) $ map (translateCmd blp) code

main = ioWrap (parser >>> component toTree >>> tdiag2picture >>> arr fromTree >>> printer)
