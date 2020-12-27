program SnakeGame;
uses crt;
type
    snakeSide = (top, left, bottom, right);

    ptrSnake = ^snake;
    snake = record
        x, y: integer;
        s: char; { symbol }
        side: snakeSide;
        next: ptrSnake;
    end;

    egg = record
       x, y: integer;
       s: char; { symbol }
   end; 

   map = record
       w, h, x, y: integer;
   end;

procedure init(var s, t: ptrSnake; var e: egg; var m: map); { Intialization }
begin
    e.x := (ScreenWidth - 1) div 2;
    e.y := ScreenHeight div 2;
    e.s := '0';
    m.w := 45; 
    m.h := 18;
    m.x := (ScreenWidth - m.w) div 2;
    m.y := (ScreenHeight - m.h) div 2;
    new(s);
    s^.x := m.x+1;
    s^.y := m.y+1;
    s^.s := '*';
    s^.side := right;
    s^.next := nil;
    t := s;
end;

procedure showMap(m: map);
var
    i, k: integer;
begin
    for i := 1 to m.h do
    begin
    GotoXY(m.x, m.y);
        write('|'); { default }
        for k := 2 to m.w-1 do
            write(' ');
        write('|');

        if i = 1 then { top }
        begin
            GotoXY(m.x, m.y);
            write(' ');
            for k := 2 to m.w-1 do
                write('_');
            write(' ');
        end;

        if i = m.h then { bottom }
        begin 
            GotoXY(m.x, m.y);
            write(' ');
            for k := 2 to m.w-1 do
                write('-');
            write(' '); 
        end;

        m.y += 1;
    end;
end;

procedure loseScreen;
begin
    delay(1000);
    GotoXY((ScreenWidth-8) div 2, ScreenHeight div 2);
    write('You lose');
    delay(2000);
    clrscr;
    halt(0);
end;

procedure winScreen;
begin
    delay(1000);
    GotoXY((ScreenWidth-7) div 2, ScreenHeight div 2);
    write('You win');
    delay(5000);
    clrscr;
    halt(0);
end;

function isFreeSpace(t: ptrSnake; x, y: integer): boolean; 
begin
    while t <> nil do
    begin
        if (x = t^.x) and (y = t^.y) then
        begin
            isFreeSpace := false;
            exit;
        end;
        t := t^.next;
    end; 
    isFreeSpace := true;
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

procedure moveEgg(var e: egg; t: ptrSnake; m: map); 
begin
    hideEgg(e);
    e.x := m.x+1 + random(m.w-1);
    e.y := m.y+1 + random(m.h-1);
    while not isFreeSpace(t, e.x, e.y) do
    begin
        e.x := m.x+1 + random(m.w-1);
        e.y := m.y+1 + random(m.h-1);
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

procedure collisionSnake(s: ptrSnake; var t: ptrSnake; var e: egg; m: map);
begin
    case s^.side of
        top:
            if (s^.x = e.x) and ((s^.y - 1) = e.y) then { Eggcrash check }
            begin
                addTail(t); 
                moveEgg(e, t, m);
            end
            else if not isFreeSpace(t, s^.x, s^.y-1) then { Tailcrash check }
                loseScreen;
        left:
            if ((s^.x - 1) = e.x) and (s^.y = e.y) then
            begin
                addTail(t);
                moveEgg(e, t, m);
            end
            else if not isFreeSpace(t, s^.x-1, s^.y) then
                loseScreen;
        bottom:
            if (s^.x = e.x) and ((s^.y + 1) = e.y) then
            begin
                addTail(t);
                moveEgg(e, t, m);
            end
            else if not isFreeSpace(t, s^.x, s^.y+1) then
                loseScreen;
        right:
            if ((s^.x + 1) = e.x) and (s^.y = e.y) then
            begin
                addTail(t);
                moveEgg(e, t, m);
            end
            else if not isFreeSpace(t, s^.x+1, s^.y) then
                loseScreen;
    end;
end;

procedure moveSnake(var s, t: ptrSnake; var e: egg; m: map); 
var
    data: snake;
    tmp: ptrSnake;
begin
    collisionSnake(s, t, e, m);
    hideSnake(t);
    tmp := t;
    data := s^;
    
    case s^.side of   { Move head }
        top:
        begin
            if s^.y = m.y+1 then
                s^.y := m.y+m.h-2
            else
                s^.y -= 1;
        end;
        left:
        begin
            if s^.x = m.x+1 then
                s^.x := m.x+m.w-2
            else
                s^.x -= 1;
        end;
        bottom:
        begin
            if s^.y = m.y+m.h-2 then
                s^.y := m.y+1
            else
                s^.y += 1;
        end;
        right:
        begin
            if s^.x = m.x+m.w-2 then
                s^.x := m.x+1
            else
                s^.x += 1;
        end;
    end;

    if t <> s then { Move tail }
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
        'w':
            if s^.side <> bottom then
                s^.side := top;
        'a': 
            if s^.side <> right then
                s^.side := left;
        's': 
            if s^.side <> top then
                s^.side := bottom;
        'd': 
            if s^.side <> left then
                s^.side := right;
        #27:
        begin
            clrscr;
            halt(0);
        end;
    end;
end;

procedure didWin(t: ptrSnake; m: map); 
var
    i, j: integer;
begin
    for i := m.x to m.x+m.w-1 do { Looking for free space }
        for j := m.y to m.y+m.h-1 do
        begin
            if isFreeSpace(t, i, j) then
                exit;
        end;
    winScreen; { Victory if no empty space }
end;

var
    sh, st: ptrSnake; { Snake`s head/tail } 
    e: egg;
    m: map;
    ch: char;
begin
    clrscr;
    randomize;
    init(sh, st, e, m);
    showMap(m);
    showSnake(st);
    showEgg(e);
    while true do
    begin
        if KeyPressed then
        begin
            ch := ReadKey;
            HandleArrowKey(sh, ch);
        end;
        didWin(st, m);
        moveSnake(sh, st, e, m);
        delay(100);
    end;
end.
