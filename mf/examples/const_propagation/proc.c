begin
    proc incr(val x, res y) is
      y := x + 1;
    end

    proc decr(val x, res y) is
      y := x - 1;
    end
    
    x := 1;
    y := x;
    while x < 5 do (
      call incr(x, z);
      call decr(x, z);

      call incr(y, x);
    )
end
