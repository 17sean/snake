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

procedure moveSnake(var s: ptrSnake); { TODO complete MoveSnake }
var
    data: snake;
    tmp: ptrSnake;
begin

    { TODO CHECK COLLISION }

    hideSnake(s);
    tmp := s;
    data := tmp^;
    
    case tmp^.side of   { TODO СДЕЛАТЬ ПРОВЕРКУ НА ПЕРЕХОД ГРАНИЦЫ }
        top:
        begin
            if tmp^.y = 1 then
                tmp^.y := ScreenHeight
            else
                tmp^.y -= 1;
        end;
        left:
        begin
            if tmp^.x = 1 then
                tmp^.x := ScreenWidth
            else
                tmp^.x -= 1;
        end;
        bottom:
        begin
            if tmp^.y = ScreenHeight then
                tmp^.y := 1
            else
                tmp^.y += 1;
        end;
        right:
        begin
            if tmp^.x = ScreenWidth then
                tmp^.x := 1
            else
                tmp^.x += 1;
        end;
    end;

    { ОБРАБЛТАТЬ ОСТАЛЬНОЕ ТЕЛО} {
    while tmp <> nil do
    begin

    end;
    }
    
    showSnake(s);
end;

procedure HandleArrowKey(var s: ptrSnake; ch: char);
begin
    case ch of
        'w': s^.side := top;
        'a': s^.side := left;
        's': s^.side := bottom;
        'd': s^.side := right;
        #27:
        begin
            clrscr;
            halt(0);
        end;
    end;
end;

var
    sh: ptrSnake; { Snake`s head }
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
        delay(100);
    end;
end.
