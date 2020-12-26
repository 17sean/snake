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

procedure showEgg(e: egg);
begin
    GotoXY(e.x, e.y);
    write(e.s);
end;

procedure hideEgg(e: egg);
begin
    GotoXY(e.x, e.y);
    write(' ');
end;

function isFreeSpace(t: ptrSnake; x, y: integer): boolean; 
begin
    while t <> nil do
    begin
        if (x = t^.x) or (y = t^.y) then
        begin
            isFreeSpace := false;
            exit;
        end;

        t := t^.next;
    end; 

    isFreeSpace := true;
end;

procedure moveEgg(var e: egg; t: ptrSnake); 
begin
    hideEgg(e);
    e.x := random(ScreenWidth) + 1;
    e.y := random(ScreenHeight) + 1;

    while not isFreeSpace(t, e.x, e.y) do
    begin
        e.x := random(ScreenWidth) + 1;
        e.y := random(ScreenHeight) + 1;
    end;

    showEgg(e);
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

procedure addTail(var t: ptrSnake); 
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

procedure collisionSnake(s: ptrSnake; var t: ptrSnake; var e: egg); { TODo crashes with body}
begin
    { for apples }
    case s^.side of
        top:
            if (s^.x = e.x ) and ((s^.y - 1) = e.y) then
            begin
                addTail(t); 
                moveEgg(e, t);
            end;
        left:
            if ((s^.x - 1) = e.x) and (s^.y = e.y) then
            begin
                addTail(t);
                moveEgg(e, t);
            end;
        bottom:
            if (s^.x = e.x) and ((s^.y + 1) = e.y) then
            begin
                addTail(t);
                moveEgg(e, t);
            end;
        right:
            if ((s^.x + 1) = e.x) and (s^.y = e.y) then
            begin
                addTail(t);
                moveEgg(e, t);
            end;
    end;

    { TODO FOR CRASHES } 
end;

procedure moveSnake(var s, t: ptrSnake; var e: egg); 
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
    {TODO НЕЛЬЗЯ ВЫБИРАТЬ ПРОТИВОЛОЖНОЕ НАПРАВЛЕНИЕ ТЕКУЩЕМУ}
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
    sh, st, tmp: ptrSnake; { Snake`s head/tail } 
    e: egg;
    ch: char;
    count: integer;
begin
    clrscr;
    randomize;
    init(sh, st, e);
    showSnake(st);
    showEgg(e);
    while true do
    begin
        GotoXY(1, 2);
        write(e.x, ' ' ,e.y);


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
