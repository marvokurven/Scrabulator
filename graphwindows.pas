Unit GraphWindows;
//{$MODE OBJFPC}

Interface
Function TextInput(x,y,sizeX,sizeY:integer; caption : String):String;
Procedure CloseWindow;

Implementation
Uses cthreads,ptcGraph, ptcCrt,sysutils, Graphics;
    
var
    Bitmap : pointer;
    MemSize : Longint;
    x1, x2, y1, y2 : integer;
    DefaultText : TextSettingsType;
    

Function TextInput(x,y,sizeX,sizeY:integer; caption : String): String;
var
    temp:string ='';
    c:char;
begin
    { Copy frame that will replace the closed window }
    GetTextSettings(DefaultText);
    memsize:= (ImageSize(x, y, x+sizeX, y+sizeY) );
     GetMem(Bitmap, memsize);
     GetImage(x, y, x+sizeX, y+sizeY, Bitmap^);
	{--Anything bellow will be replaced with the copied bitmap when the window closes--}
     
     SetColor(9);
     SetLineStyle(SolidLn,0,ThickWidth);    
     Rectangle(x+2, y+2, sizeX+x-2, sizeY+y-2); // Draw window border

     SetLineStyle(SolidLn,0,NormWidth);
     Rectangle(x+3, y+3, sizeX+x-3, y+30); // Draw title bar

     SetFillStyle(CloseDotFill,blue);
     Floodfill(x+10,y+10,9);  // Fill title bar

      SetFillStyle(InterleaveFill,blue);
      Floodfill( (x+50),(y+50),9); // Fill window	
	
	SetColor(yellow);
	
	 SetTextJustify(CenterText,CenterText);
	 SetTextStyle(TriplexFont,HorizDir,2);
	 OutTextXY(x +sizeX div 2, (y+18), caption); // Draw caption
	 SetColor(white);
	 SetTextStyle(SmallFont,HorizDir,1);
	   OutTextXY(x +sizeX div 2, (y+sizeY-30), 'ENTER: Accept           ESC: Cancel');
		SetColor(white);
	   Rectangle(x +50, y +60, x +sizeX -50, y +90);  // Draw text-box
	   SetFillStyle(CloseDotFill,9);
	   Floodfill(x + 65, y +65, white);

	   SetTextStyle(SmallFont,HorizDir,2);

	   while (ord(c) <> 13) do  // Input text
		    begin
			  c:=Readkey;
			  case ord(c) OF
				97..122 : temp:= (temp +UpCase(c));
				27      : break;
			  end;

			  SetFillStyle(CloseDotFill,9);
			  Floodfill(x + 65, y +65, white);
			  SetColor(green);
			  OutTextXY(x +sizeX div 2, y +77, temp); // Show text in textbox
			end;
					
  PutImage(x, y, Bitmap^, CopyPut); // Remove the window by putting the bitmap back into the framebuffer
  FreeMem(Bitmap, memsize); 		// Discard the bitmap

  SetLineStyle(SolidLn,0,NormWidth);
  SetTextJustify(DefaultText.horiz,DefaultText.vert); // Return text to default
  EXIT(temp);
end;

Procedure CloseWindow;
begin
    // NOTHING TO DO HERE YET
end;


begin
    end.
