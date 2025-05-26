program ScrabbleBoard;
//{$MODE OBJFPC}


uses
    {$IFDEF UNIX}
      cthreads,
    {$ENDIF}
    ptcGraph, ptcCrt,sysutils, Graphics, GraphWindows;

   
var
    gm, gd : integer;
    key : WideChar;

   

Procedure move(direction : word);
begin
    if (SelY <> 0) and (direction=72) then 	// Move up
    begin
  	  Tile[SelX,SelY].Selected:=false;	
	  ReDraw(SelX,SelY);
	  dec(SelY);
	  Tile[SelX,SelY].Selected:=true;
	    ReDraw(SelX,SelY);
    end;
    
    if (SelY < 14) and (direction=80) then 	// Move Down
    begin
	Tile[SelX,SelY].Selected:=false;
	   ReDraw(SelX,SelY);
	   inc(SelY);
	Tile[SelX,SelY].Selected:=true;
	ReDraw(SelX,SelY);
    end;
    
    if (SelX <> 0) and (direction=75) then 	// Move Left
    begin
	  Tile[SelX,SelY].Selected:=false;
		ReDraw(SelX,SelY);
		dec(SelX);
	  Tile[SelX,SelY].Selected:=true;
		ReDraw(SelX,SelY);
    end;
    
    if (SelX < 14) and (direction=77) then 	// Move Right
    begin
	  Tile[SelX,SelY].Selected:=false;
	  	ReDraw(SelX,SelY);
		inc(SelX);
	  Tile[SelX,SelY].Selected:=true;
		ReDraw(SelX,SelY);
    end;


end;

function ReadExtendedKey: WideChar;
var
    byte1, byte2: byte;
begin
  // Get the first byte of the keypress
    byte1 := Ord(ReadKey);

  // Check for extended characters by looking at the first byte
    if (byte1 >= $C0) then
    begin
    // If it's an extended character, read the next byte
	  byte2 := Ord(ReadKey);

    // Combine the bytes into a UTF-8 character
	  Exit(WideChar((byte1 shl 8) or byte2)); // Handle multi-byte UTF-8
    end
    else
    begin
    // If it's a normal ASCII character, return it as a WideChar
	  Exit(WideChar(byte1));
    end;
end;


Procedure RemoveLetter;
begin
    Tile[SelX,SelY].Letter:= ' '; 
    ReDraw(SelX,SelY);
end;


Procedure PlaceLetter(Letter:char);
begin
    Tile[SelX,SelY].Letter:= (Letter);
    ReDraw(SelX,SelY);
end;


Procedure EditRack;
var
    temp:char;

begin
    temp:=(TextInput(100,200,500,200,'Enter rack letters')[1]); // Show Dialog
    
  
   
    DrawRack;
end;


Procedure Compute;
begin
    // NOTHING TO DO HERE YET
end;


Procedure reset; // Draw everything, and reset all values 
begin
    selX:=7;
    SelY:=7;
    DrawBoard;  
    DrawRack;
	ReDraw(SelX,SelY);
    SetTextStyle (0,0,2);
end;
    

begin
	{ Initialize the graphics mode }
	gd := D8bit;
	gm := m1024x768;
	InitGraph(gd, gm, '');

	if GraphResult <> grOk then
	begin
		WriteLn('Graphics mode not supported');
		Halt(1);
	end;

	{ Draw the Scrabble board's background }
		Tile[SelX,SelY].Selected:=True;
		SetColor(9);
		Rectangle(0,0,1023,767);
		SetFillStyle(WideDotFill,9);
		Floodfill(5,5,9);
	reset; // Draw the actual board
	  

	While (ord(key) <> 27) do 
	Begin
	    
	     Key:=ReadExtendedKey;
//	    Key:=Readkey;

	     Case ord(key) OF
		   72, 80, 75, 77 : Move(ord(Key));			// Up, Dn, L, R
		   97..122		: PlaceLetter(UpCase(key));  	//A..Z
		   83			: RemoveLetter;  			//DEL
		   67			: EditRack; 			//F9
		   134		: Compute;  			//F12
		   59			: reset;				//F1
		   63			: PlaceLetter(WideChar($00C6));  //F5 : Æ - Not working atm
		   64			: PlaceLetter(WideChar($00D8));  //F6 : Ø - Not working atm
		   65			: PlaceLetter(WideChar($00C5));  //F7 : Å - Not working atm
	     end;
	     
	   {   case key OF
		    WideChar($00E6): PlaceLetter(key);  // æ
		    WideChar($00F8): PlaceLetter(key);  // ø
		    WideChar($00E5): PlaceLetter(key);  // å
	     end;
		}   

	 end;

	{ Close the graphics mode }
	CloseGraph;
	writeln ((Tile[0,0].Letter)+(Tile[1,0].Letter)+(Tile[2,0].Letter));
end.
