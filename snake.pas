program SnakeGame;
uses crt;
type
    SnakeSide = (top, left, bottom, right);

    ptrSnake = ^snake;
    snake = record
        x, y: integer;
        s: char; { symbol }
        side: SnakeSide;
        prev: ptrSnake;
    end;

    egg = record
       x, y: integer;
       s: char;
   end; 

procedure init(var s: ptrSnake; var e: egg);
begin
    new(s);
    s^.x := 1;
    s^.y := 1;
    s^.s := '*';
    s^.side := right;
    s^.prev := nil;
    e.x := (ScreenWidth - 1) div 2;
    e.y := ScreenHeight div 2;
    e.s := '0';
end;

procedure showSnake(s: ptrSnake);
begin
    while s <> nil do
    begin
        GotoXY(s^.x, s^.y);
        write(s^.s);
        s := s^.prev;
    end;
end;

procedure hideSnake(s: ptrSnake);
begin
    while s <> nil do
    begin
        GotoXY(s^.x, s^.y);
        write(' ');
        s := s^.prev;
    end;
end;

function collisionSnake(): boolean; { Check apples & crashes with body }
begin

end;

procedure moveSnake(var s: ptrSnake);
begin
    { CHECK FOR COLLISION }
end;

procedure HandleArrowKey(var s: ptrSnake; ch: char);
begin
    case ch of
        'w': s^.side := top;
        'a': s^.side := left;
        's': s^.side := bottom;
        'd': s^.side := right;
    end;
end;

var
    sh, tmp: ptrSnake; { Snake`s head }
    e: egg;
    ch: char;
begin
    clrscr;
    init(sh, e);
    showSnake(sh);
    while true do
    begin
        if KeyPressed then
        begin
            ch := ReadKey;
            HandleArrowKey(sh, ch);
        end;

        moveSnake(sh);
        delay(500);
    end;
end.
