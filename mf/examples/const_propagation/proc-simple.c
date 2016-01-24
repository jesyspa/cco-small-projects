begin
    proc foo(val x, res y) is
        skip ;
    end

    x := 1 ;
    call foo(x, y) ;
    y := x ;
end
