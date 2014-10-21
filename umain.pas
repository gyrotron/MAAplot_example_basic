unit umain;
{
Basic example showing the use of MAAPlot within a Lazarus/fpc project
(C) 2014 Stefan Junghans
www.junghans-electronics.de
MAAPlot (at) junghans-electronics . de
}
{
When the example is working check out
- Context menu with right mouse button into plot area
- Pan the plot (shift + left mouse)
- Zoom (mouse wheel or shift + wheel)
- AdHoc Marker (CTRL + left mouse)

}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  uPlotClass,
  uPlotRect,
  uPlotAxis,
  uPlotSeries,
  uPlotStyles
  ;

type

  { TForm1 }

  TForm1 = class(TForm)
    FPlot: TPlot;
    btn_filldata: TButton;
    GroupBox1: TGroupBox;
    procedure btn_filldataClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MakePlot;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.btn_filldataClick(Sender: TObject);
var
  vLoop: Integer;
  x, y: Extended;
begin
  // generate some dummy data and add the XY values to our plot
  for vLoop := -10 to 10 do begin
    x := vLoop;
    y := sqr(vLoop);
    TXYPlotSeries(FPlot.Series[0]).AddValue(x,y);
  end;

  // autoscaling is NOT triggered automatically
  // if you want automatic scaling, please call autoscale after adding data
  FPlot.AutoScaleSeries(0);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FPlot.Free;  // free the plot
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MakePlot;    // establish a plot
end;

procedure TForm1.MakePlot;
begin
  // we will create a very basic 2D plot ....

  // 1. create a TPLot
  // This creates an empty container ready to add plotrects, axes and series
  FPlot := TPlot.Create(Self);   // create a TPLot (container for all further plot elements)
  FPlot.Parent := GroupBox1;     // put it into a control
  FPlot.Align := alClient;       // align with the methods of a TWinControl

  // 2. Create a PlotRect
  // The PlotRect actually is our DataPlot container
  // Note for your experiments:
  // A TPlot could contain more than one PlotRect
  // You could present two dataplots (plotrects) on top of each other
  // for example:
  // (FPlot.PlotRect[0]).BorderRel := Rect(0,0,0,52)
  // (FPlot.PlotRect[1]).BorderRel := Rect(0,48,0,0)
  // You could remember the plotrect in a global variable like FPlotRect0
  // or you can adress the plotrect via its index TPLotRect(FPLot.PLotRect[index])
  TPlotRect.Create(FPlot);
  with TPLotRect(FPlot.PlotRect[0]) do begin
    BorderAbs := Rect(12,12,12,12);
    Title := 'Title';
  end;

  // 3. create two axes
  // a 2D plot will need 2 axes
  // Note for your experiments:
  // The plotrect might contain more than 2 axes, even for 2D plotting
  // You could have one common X axis and two different Y axes
  // You could display the second Y axis at the right side of the plot
  TPlotAxis.Create(FPlot);
  with TPlotAxis(FPlot.Axis[0]) do begin
    //Orientation := aoHorizontal; // aoHorizontal is the same as aoVariable with Drawangle = 0
    Orientation := aoVariable;     // aoVariable;
    DrawAngle := 0;                // 0 degrees for basic X axis
    TickAngle := taNegative;       // default tick angle is positive, so adjust it as neccessary
    AutoMode := lmRelToWidth;      // X axis length is adjusted according to plotrect width
    //DrawLength:=100;             // defaults to 100%
    AxisLabel := 'X axis';
    OwnerPlotRect := OwnerPlot.PlotRect[0];   // the axis needs a OwnerPlotRect
  end;
  TPlotAxis.Create(FPlot);
  with TPlotAxis(FPlot.Axis[1]) do begin
    Orientation := aoVariable;
    DrawAngle := 90;               // 90 degrees for basic Y axis
    AutoMode := lmRelToHeight;     // X axis length is adjusted according to plotrect width
    AxisLabel := 'Y axis';
    OwnerPlotRect := OwnerPlot.PlotRect[0];
  end;

  // 4. create a series (our dataseries)
  // Note for your experiments:
  // Multiple Series could be plotted into one PlotRect
  // However the series should be of the same type (i.e. TXYPlotSeries)
  TXYPlotSeries.Create(FPlot);
  with TXYPlotSeries(FPlot.Series[0]) do begin
    XAxis := 0;                    // 2D series need a X and Y axis (give the index of a axis contained in FPLot)
    YAxis := 1;
    Style := TSeriesStylePoints.Create;        // Points or Lines....
    TSeriesStylePoints(Style).Color := clRed;
    TSeriesStylePoints(Style).Diameter := 7;   // we like red points with a diameter of 7 pixel
  end;
  // 5. do some adjustments...
  TPlotAxis(FPlot.Axis[0]).AddInnerGridAxis(1);  // show X inner ticks parallel to Y axis
  TPlotAxis(FPlot.Axis[1]).AddInnerGridAxis(0);  // show Y inner ticks parallel to X axis

  FPlot.AutoScaleSeries(0);                      // perform a autoscale (also possible via context menu)
  //FPlot.Repaint;                               // redrawing is done automatically

end;

end.

