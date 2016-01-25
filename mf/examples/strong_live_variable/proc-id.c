begin
    proc id(val y, res z) is
        z := y ;
    end

    x := 5 ;
    x := x + 1 ;
    call id(x, z) ;
end
