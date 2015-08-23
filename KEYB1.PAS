{$R-}{$Q-}{$I-}{$S-}{$E-}{$N+}{$G+}{$A+}
unit Keyb1;
interface
{uses CRT;}
const F1   =#59;
const F2   =#60;
const F3   =#61;
const F4   =#62;
const F5   =#63;
const F6   =#64;
const F7   =#65;
const F8   =#66;
const F9   =#67;
const f10  =#68;
const f11  =#133;
const f12  =#134;

const Esc  =#27;
const enter=#13;

const UpL  =#71;
const Up   =#72;
const UpR  =#73;
const Left =#75;
const Right=#77;
const DownL=#79;
const Down =#80;
const DownR=#81;

const Ins  =#82;
const del  =#83;


var key,key1: char;

Procedure Rkey;
procedure Keyp;
implementation
{Procedure Rkey;
begin
 key:=readKey;
 if key=#0 then key1:=readKey;
end;}
procedure Rkey;assembler;{= key:=readkey; if key=#0 then key1:=readKey; but always gives special key1, time-equal}
asm
  mov ah,$00
  int 16h
  mov key,Al
  mov key1,Ah
end;

procedure Keyp;assembler;{= if keyPressed then Rkey; but a bit faster}
label keyNotPressed;
asm
  mov ah,$01
  int 16h
  jz keyNotPressed
    mov ah,$00    {is there any way to avoid it? $01 just doesn't read next char.}
    int 16h
    mov key,Al
    mov key1,Ah
keyNotPressed:
end;

BEGIN
END.