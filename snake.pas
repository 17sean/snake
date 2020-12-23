program Snake;
uses crt;
type
    ptrSnake = ^Snake;
    snake = record
        x, y: integer;
        s: char; { symbol }
    end;

    egg = record
       x, y: integer;
       s: char;
   end; 

procedure init();

procedure showSnake();

procedure hideSnake();

function collisionSnake(): boolean;

procedure moveSnake();

procedure HandleArrowKey();

var
    sh, tmp: ptrSnake; { Snake`s head }
begin
    
end.
