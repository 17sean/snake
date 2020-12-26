program SnakeGame;
uses crt;
type
    SnakeSide = (top, left, bottom, right);

    ptrSnake = ^snake;
    snake = record
        x, y: integer;
        s: char; { symbol }
        side: SnakeSide;
        next: ptrSnake;
    end;

    egg = record
       x, y: integer;
       s: char;
   end; 

procedure init(var s, t: ptrSnake; var e: egg);
var
    tmp: ptrSnake;
begin
    new(s);
    s^.x := 2;
    s^.y := 1;
    s^.s := '*';
    s^.side := right;
    s^.next := nil;
    t := s;
    e.x := (ScreenWidth - 1) div 2;
    e.y := ScreenHeight div 2;
    e.s := '0';
end;

procedure showSnake(t: ptrSnake);
begin
    while t <> nil do
    begin
        GotoXY(t^.x, t^.y);
        write(t^.s);
        t := t^.next;
    end;
end;

procedure hideSnake(t: ptrSnake);
begin
    while t <> nil do
    begin
        GotoXY(t^.x, t^.y);
        write(' ');
        t := t^.next;
    end;
end;

procedure addTail(var t: ptrSnake); { TODO add part for tail } 
var
    tmp: ptrSnake;
begin
    new(tmp);
    tmp^.x := t^.x;
    tmp^.y := t^.y;
    tmp^.s := t^.s;
    tmp^.side := t^.side;
    tmp^.next := t;
    t := tmp;
end;

procedure collisionSnake(s: ptrSnake; var t: ptrSnake; e: egg); { TODo crashes with body, дописать систему яйца}
begin
    { for apples }
    case s^.side of
        top:
            if (s^.x = 10 {коор яйца}) and ((s^.y - 1) = 2) then
                addTail(t); { todo }
        left:
            if ((s^.x - 1) = 10) and (s^.y = 2) then
                addTail(t);
        bottom:
            if (s^.x = 10) and ((s^.y + 1) = 2) then
                addTail(t);
        right:
            if ((s^.x + 1) = 10) and (s^.y = 2) then
                addTail(t);
    end;

    { TODO FOR CRASHES } 
end;

procedure moveSnake(var s, t: ptrSnake; e: egg); { TODO complete MoveSnake }
var
    data: snake;
    tmp: ptrSnake;
begin
    collisionSnake(s, t, e);
    hideSnake(t);
    tmp := t;
    data := s^;
    
    case s^.side of   { Move head }
        top:
        begin
            if s^.y = 1 then
                s^.y := ScreenHeight
            else
                s^.y -= 1;
        end;
        left:
        begin
            if s^.x = 1 then
                s^.x := ScreenWidth
            else
                s^.x -= 1;
        end;
        bottom:
        begin
            if s^.y = ScreenHeight then
                s^.y := 1
            else
                s^.y += 1;
        end;
        right:
        begin
            if s^.x = ScreenWidth then
                s^.x := 1
            else
                s^.x += 1;
        end;
    end;

    if t <> s then { Body move }
    begin
        while tmp^.next <> s do
        begin
            tmp^.x := tmp^.next^.x;
            tmp^.y := tmp^.next^.y;
            tmp := tmp^.next;
        end;
        tmp^.x := data.x;
        tmp^.y := data.y;
    end;

    showSnake(t);
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
    sh, st, tmp: ptrSnake; { Snake`s head/tail } { todo do system for egg }
    e: egg;
    ch: char;
    count: integer;
begin
    clrscr;
    init(sh, st, e);
    showSnake(st);
    while true do
    begin
        gotoxy(10, 2);
        write('0');


        if KeyPressed then
        begin
            ch := ReadKey;
            HandleArrowKey(sh, ch);
        end;

        moveSnake(sh, st, e);
        delay(100);
        tmp := st;
        count := 0;
        while tmp <> nil do
        begin
            count += 1;
            tmp := tmp^.next;
        end;


        gotoxy(1,1);
        write(count)
    end;
end.
