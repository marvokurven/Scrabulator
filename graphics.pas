UNIT Graphics;

interface

Const
BoardSize = 15;	{ Scrabble board size (15x15 grid) }
TileSize = 45;	{ Size of each tile in pixels }
Bordersize = 4;	{ Border width in pixels }

Type 
    Tiledata = RECORD
			 Letter : Widechar;
			 Point: integer;
			 PosX,PosY,PosX2,PosY2 : integer;
			 Placed,Selected : Boolean;
		   end;
Type 
    Rackdata = RECORD
			 Letter : char;
			 placed : Boolean;
		   end;
    

var
    SelX : integer = 7;
    SelY : integer = 7;
    Tile: Array [0..BoardSize-1, 0..BoardSize-1] of Tiledata;
    RackTile : Array [0..6] of Rackdata;


Procedure DrawBoard;
Procedure ReDraw(j,i: integer);
Procedure DrawRack;


implementation


uses
    cthreads,ptcGraph, ptcCrt, sysutils;

const
   
    BorderColor = Blue;
    TileColor = 2;{ Color of empty spaces, dark green }
    LetterColor =7; { Color of tiles with letters. 15}
    FillStyle1 = CloseDotFill; {Fill style 1, empty tiles}
    FillStyle2 = SolidFill; {Fill style 2, placed tiles}
    SelColor = Yellow;	{Color of selection marker}
 //   all = 0,0,1024,768;
 //   rack = 10,700,700,760;
var
    i, j   : integer;


Procedure ReDraw(j,i: integer);
begin
    SetColor(TileColor);
    if Tile[j,i].Letter <> ' ' then begin		//Draw letter tile
	  SetColor(LetterColor);
	  SetFillStyle(Fillstyle2,LetterColor);
	  	Rectangle (Tile[j,i].PosX, Tile[j,i].PosY, Tile[j,i].PosX2, Tile[j,i].PosY2);
	  	FloodFill(Tile[j,i].PosX + (TileSize div 2), Tile[j,i].PosY + (TileSize div 2), LetterColor);
	   	 SetColor(black);
	   	 SetTextStyle(EuroFont,HorizDir,2);
	  	OutTextXY(Tile[j,i].PosX +(TileSize div 3), Tile[j,i].PosY +(TileSize div 3),Tile[j,i].Letter);
	   SetColor(red);
	   SetTextStyle(BoldFont,HorizDir,1);
	   	OutTextXY(Tile[j,i].PosX +2, Tile[j,i].PosY +(TileSize -12),IntToStr (Tile[j,i].Point) );
    end;
  
    
   { If (i=7) and (j=7) and (Tile[j,i].Letter = ' ') then begin	//Draw center square
	  SetColor(3);
	  SetFillStyle(FillStyle1, 3);
	  Rectangle (Tile[j,i].PosX, Tile[j,i].PosY, Tile[j,i].PosX2, Tile[j,i].PosY2);
	  FloodFill(Tile[j,i].PosX + (TileSize div 2), Tile[j,i].PosY + (TileSize div 2), 3);
    end;
   }
    if Tile[j,i].Letter = ' ' then begin		//Draw empty tile
	  SetColor(TileColor);
	  If (i=7) and (j=7) then
		SetFillStyle(FillStyle1, 3)
	  else
		SetFillStyle(FillStyle1, TileColor);
	  Rectangle (Tile[j,i].PosX, Tile[j,i].PosY, Tile[j,i].PosX2, Tile[j,i].PosY2);
	  FloodFill(Tile[j,i].PosX + (TileSize div 2), Tile[j,i].PosY + (TileSize div 2), TileColor);
    end;

    if Tile[j,i].Selected then 	//Draw cursor
    begin
	  SetColor(SelColor);
	  SetLineStyle(DashedLn,0,NormWidth);
	  Rectangle (Tile[j,i].PosX, Tile[j,i].PosY, Tile[j,i].PosX2, Tile[j,i].PosY2);
	  SetLineStyle(SolidLn,0,NormWidth);
    end;
    
    Outtextxy(800,100,'X: ' +IntToStr(j) +(' - Y: ') +Inttostr(i) );
end;

Procedure DrawRack;
const
    TileWidth = 45;
var
    n : integer;
begin
    //setViewPort(10,700,700,760,false);
    SetColor(3);
    SetFillStyle(FillStyle1, BorderColor);
    Rectangle(1,700,713,766);
    FloodFill(5,720,3);
    SetColor(BorderColor);
    Rectangle(1,700,713,766);
    
    SetColor(3);
    for n := 0 to 6 do
    begin
	//  sleep(150);
	  SetFillStyle(InterLeaveFill,3);
	  Bar3D( (n*TileWidth+30+(n*30)),714,(n*TileWidth+30+(n*30)) +TileWidth,714+TileWidth,7,true ); 
    
	  SetFillStyle(CloseDotFill,3);
	 FloodFill(10+(n*TileWidth+35+(n*30)),710,3); // Top shaddow
	  SetFillStyle(WideDotFill,3);
    	 FloodFill(n*TileWidth+35+(n*30) +TileWidth,680+TileWidth,3); // Right shaddow
	 
    end;
    setcolor(yellow);
    SetTextStyle(DefaultFont,HorizDir,1);
    OutTextXY(550,707,'ESC: Exit');
    OutTextXY(550,723,'F1 : Reset game');
    OutTextXY(550,738,'F9 : Edit rack tiles');
    OutTextXY(550,753,'F10: Compute');
    
end;

procedure DrawBoard;
var
    x  : integer =1;
    y  : integer =1;
begin
    SetColor(BorderColor);
    SetLineStyle(SolidLn,0,NormWidth);
    Rectangle (x,y,
		   ( (BoardSize*TileSize) +(BoardSize*BorderSize) -(TileSize div 2)),
		   ( (BoardSize*TileSize) +(BoardSize*BorderSize) -(TileSize div 2)) );
    // readkey;

    SetFillStyle(WideDotFill, BorderColor);
    FloodFill(x + 5, y + 5, BorderColor);
   //  readkey;

    for i := 0 to BoardSize - 1 do // I: Vertical
    begin
	  for j := 0 to BoardSize - 1 do // J: Horizontal
	  begin
	//	sleep(10);
//		x := (j * TileSize +BorderSize +10 );
//		y := (i * TileSize +BorderSize +10 );
		{
		Tile[j,i].PosX:=(j * TileSize +BorderSize +BorderSize +10 );
		Tile[j,i].PosY:=(i * TileSize +BorderSize +BorderSize +10 );
		Tile[j,i].PosX2:=(j * TileSize +BorderSize +TileSize +10 );
		Tile[j,i].PosY2:=(i * TileSize +BorderSize +TileSize +10 );}
		with Tile[j,i] do
		begin
		    PosX:=(j * TileSize +BorderSize +BorderSize +10 );
		    PosY:=(i * TileSize +BorderSize +BorderSize +10 );
		    PosX2:=(j * TileSize +BorderSize +TileSize +10 );
		    PosY2:=(i * TileSize +BorderSize +TileSize +10 );
		    Letter:= ' ';
		    Point:=i;
		end;
	  	
			{ Draw the square for each tile }
		SetColor(TileColor);

//		Rectangle( (x+BorderSize), (y+BorderSize), 
//			     (x+TileSize), (y+TileSize));
		Rectangle (Tile[j,i].PosX, Tile[j,i].PosY, Tile[j,i].PosX2, Tile[j,i].PosY2);
		If (i=7) and (j=7) then
		    SetFillStyle(FillStyle1, 3)
		else
		    SetFillStyle(FillStyle1, TileColor);

		FloodFill(Tile[j,i].PosX + (TileSize div 2), Tile[j,i].PosY + (TileSize div 2), TileColor);

		
			//readkey;
	  end;
    end;
end;

begin
    end.
