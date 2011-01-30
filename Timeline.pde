/* CS 486: Information Visualization
 * Final Visualization Project
 *
 * Rodrigo Thauby
 */

public class Timeline {

  int _width = 1024;
  int _height = 150;
  TimelineApplet applet;
  TimelineFrame frame;

  public Timeline(DataLoader _data) {
    frame = new TimelineFrame(_width,_height);
    applet = new TimelineApplet(_data,_width,_height);

    frame.add(applet);
    applet.init();
    frame.show();
  }
}

public class TimelineFrame extends Frame {

  public TimelineFrame(int width, int height) {
    setBounds(0,0,width,height+25);
  }
}

public class TimelineApplet extends PApplet {

  DataLoader data;     // data values
  int[] yearMarks, monthMarks;
  int plotX1, plotY1;  // upper-left corner of plot area
  int plotX2, plotY2;  // lower-right corner of plot area
  int desiredWidth, desiredHeight;
  int skipYearMarks = 4;

  public TimelineApplet(DataLoader _data, int _width, int _height) {
    data = _data;
    desiredWidth = _width;
    desiredHeight = _height;
  }

  public void setup() {
    debug("Initializing timeline window...");

    size(desiredWidth, desiredHeight);
    smooth();

    // initialize plot area
    plotX1 = 60;
    plotY1 = 60;
    plotX2 = width - plotX1;
    plotY2 = height - 60;

    yearMarks = new int[data.numberOfYears];
    monthMarks = new int[data.numberOfYears * 12];

    for(int i = 0; i < yearMarks.length; i++)
    {
      // equally place columns in space between plotX1 and plotX2
      yearMarks[i] = round(map(i, 0, yearMarks.length - 1, plotX1, plotX2));
    }
    for(int i = 0; i < monthMarks.length; i++)
    {
      // equally place columns in space between plotX1 and plotX2
      monthMarks[i] = round(map(i, 0, monthMarks.length - 1, plotX1, plotX2));
    }
  }

  public void draw() {
    background(230);
    drawPlot();
    drawArea();
    drawSection();
  }
  
  void drawSection(){
    
    int width = round((plotX2 - plotX1) / data.numberOfYears);
    int height = plotY2 - plotY1 - 1;
    
    int x = monthMarks[startMonth];
    int y = plotY1;
    
    stroke(255,0,0);
    strokeWeight(1);
    rectMode(CORNER);
    rect(x,y,width,height);
    noStroke();
  }

  void drawArea()
  {
    noStroke();
    fill(247,182,8);
    beginShape();

    vertex(plotX2, plotY2);
    vertex(plotX1, plotY2);

    for(int i = 0; i < monthMarks.length; i++)
    {
      int month = data.monthlyData[i];

      int x = monthMarks[i];
      int y = round(map(month, 0, data.yMax, plotY2, plotY1));

      vertex(x,y);
    }

    endShape();

    noStroke();
    noFill();
  }

  void drawPlot()
  {
    fill(0);
    stroke(0);
    textSize(9);

    line(plotX1,plotY2,plotX2,plotY2);
    line(plotX1,plotY2,plotX1,plotY1);

    for(int i = 0; i < yearMarks.length; i++)
    {
      if(i % skipYearMarks == 0)
      {
        textAlign(CENTER, TOP);
        text((data.minYear + i), yearMarks[i],plotY2 + 8);
      }
    }

    textAlign(RIGHT, CENTER);
    text(data.yMax + "\nun/month", plotX1 - 2, plotY1);
    
    noStroke();
    noFill();
  }
}

