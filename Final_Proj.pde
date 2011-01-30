/* CS 486: Information Visualization
 * Final Visualization Project
 *
 * Rodrigo Thauby
 */

color colorA = color(247,182,8);
color colorB = color(255,255,255);
int width = 1024;
int height = 600;
PFont plotFont;               // font for text labels
Timeline timeline;            // timeline class
DataLoader data;              // data values
int samples, lines;
int[][] values;
int[][] absValues;
boolean stroke = true;
boolean peaks = false;
boolean highlighting = false;
Category cat;
int selectedCategory = 0;
int categoryId = 1;

  // View specifics
  int[] yearMarks, monthMarks;
  int plotX1, plotY1;  // upper-left corner of plot area
  int plotX2, plotY2;  // lower-right corner of plot area
  int numberOfYearsToShow = 1;
  int startMonth = 420; // That's Jan 2010 in months terms
  int firstYear = 1975;
  
  
  String[] monthLabels;

void setup() 
{
  debug("Initializing main window...");
  
  size(width,height);
  smooth();

  // initialize plot area
  plotX1 = 60;
  plotY1 = 40;
  plotX2 = width - plotX1;
  plotY2 = height - 40;
  
  monthLabels = new String[12];
  monthLabels[0] = "Jan";
  monthLabels[1] = "Feb";
  monthLabels[2] = "Mar";
  monthLabels[3] = "Apr";
  monthLabels[4] = "May";
  monthLabels[5] = "Jun";
  monthLabels[6] = "Jul";
  monthLabels[7] = "Aug";
  monthLabels[8] = "Sep";
  monthLabels[9] = "Oct";
  monthLabels[10] = "Nov";
  monthLabels[11] = "Dec";
  
  plotFont = createFont("SansSerif", 12, true);
  data = new DataLoader("games-large.csv");
  cat = new Category(data.genres);
  samples = numberOfYearsToShow * 12;
  lines = data.genres.length;
  timeline = new Timeline(data);
  
  monthMarks = new int[12];
  
  for(int i = 0; i < monthMarks.length; i++)
  {
    // equally place columns in space between plotX1 and plotX2
    monthMarks[i] = round(map(i, 0, monthMarks.length - 1, plotX1, plotX2));
  }
  
  debug(data.numRows() + " rows and " + data.numCols() + " columns loaded.");
  debug("Initialization complete.");
}

void draw() 
{
  background(230);
  drawGrid();
  drawYear();
  getValues();
  drawArea();
  if(peaks) writePeaks();
  drawPlot();
}

void drawYear(){
  fill(0,0,0,16);
  textSize(120);
  textAlign(CENTER, TOP);
  int currYear = (startMonth / 12) + firstYear;
  text(currYear, round((plotX2 - plotX1) / 2) + 70, plotY1 + 100);
  textSize(12);
}

void getValues()
{
  absValues = new int[lines][samples];
  values = new int[lines][samples];
  int[] sums = new int[samples];
  for(int i=0; i<samples; i++) {sums[i]=0;}
  for(int i=0; i<lines; i++){
    
    int monthIndex = 0;
    String keyname = (String) cat.applet.categories[i];
    
    for(int j = startMonth; j < (startMonth + numberOfYearsToShow * 12); j++){
      ArrayList listArr = new ArrayList();
      switch(categoryId){
        case 1:
          listArr = (ArrayList) data.genreData.get(keyname);
          break;
        case 2:
          listArr = (ArrayList) data.platformData.get(keyname);
          break;
      }
      
      ArrayList month = (ArrayList) listArr.get(j);
      int yValue = month.size();
      sums[monthIndex] += yValue;
      values[i][monthIndex] = sums[monthIndex];
      absValues[i][monthIndex] = yValue;
      monthIndex++;
    }
    
       
  }
}

void writePeaks(){
  int i = lines-1;
  
  if(!highlighting){
    fill(100);
    for(int j=0; j<samples; j++){
        textAlign(CENTER, BOTTOM);
        int y = round(map(values[i][j], 0, data.yMax, plotY2, plotY1));
        text(values[i][j], monthMarks[j], y - 10);
    } 
  } 
  
  if(highlighting){
    i = selectedCategory;
    fill(0);
    for(int j=0; j<samples; j++){
        textAlign(CENTER, BOTTOM);
        int y = round(map(values[i][j], 0, data.yMax, plotY2, plotY1));
        text(absValues[i][j], monthMarks[j], y - 10);
    }
  }
  
  noFill();
}

void drawArea()
{  
  for(int i=lines-1; i>=0; i--){
    stroke(255);
    if(stroke) strokeWeight(0.5);
    else noStroke();
    
    float lerpIndex = parseFloat(i) / parseFloat(lines);
    color fillColor = lerpColor(colorA,colorB,lerpIndex);
    if(highlighting && selectedCategory != i) fill(180);
    else if(highlighting) fill(colorA);
    else fill(fillColor);
    beginShape();
    
    vertex(plotX1, plotY2);

    
    for(int j=0; j<samples; j++){
      // Vertices go here
      int x = monthMarks[j];
      int y = round(map(values[i][j], 0, data.yMax, plotY2, plotY1));
      vertex(x,y);      
    }
    
    

    vertex(plotX2, plotY2);
    
    endShape();
    
    noStroke();
    noFill();
  }    
}

int monthToYear(int month)
{
  return (firstYear + (month / 12));
}

void drawPlot()
{
  fill(0);
  stroke(0);
  strokeWeight(1);
  textSize(9);

  line(plotX1,plotY2,plotX2,plotY2);
  line(plotX1,plotY2,plotX1,plotY1);

  for(int i = 0; i < monthMarks.length; i++)
  {
      textAlign(LEFT, TOP);
      text(monthLabels[i], monthMarks[i], plotY2 + 8);
      text(str(monthToYear(startMonth)), monthMarks[i], plotY2 + 20);
  }

  textAlign(RIGHT, CENTER);
  for(int i=0; i<5; i++){
    int yHeight = round(plotY1 + (parseFloat(plotY2 - plotY1) / 5) * i);
    text(round((parseFloat(data.yMax) / 5) * (5 - i)) + "\nun/month", plotX1 - 8, yHeight);
  }

  noStroke();
  noFill();
}

void drawGrid(){
  stroke(248);
  for(int i=0; i<5; i++){
    int yHeight = round(plotY1 + (parseFloat(plotY2 - plotY1) / 5) * i);
    line(plotX1,yHeight,plotX2,yHeight);
  }

  noStroke();
  noFill();
}

void switchToCategoryId(int id){
  categoryId = id;
  switch(id){
    case 1:
      cat.applet.categories = data.genres;
      lines = data.genres.length;
      break;
    case 2:
      cat.applet.categories = data.platforms;
      lines = data.platforms.length;
      break;
  }
}

void keyPressed()
{
  switch(key){
    case '1':
      selectedCategory=0;
      switchToCategoryId(1);
      break;
    case '2':
      selectedCategory=0;
      switchToCategoryId(2);
      break;
    case 'h':
      highlighting = !highlighting;
      if(highlighting) selectedCategory=0;
      break;
    case 's':
      stroke = !stroke;
      break;
    case 'p':
      peaks = !peaks;
      break;
    case '-':
    case '_':
    case '[':
      if(startMonth > 0) startMonth -= 12;
      break;
    case '+':
    case '=':
    case ']':
      if(startMonth < 432) startMonth += 12;
      break;
  }
  
  if(key == CODED)
  {

    if(keyCode == UP && selectedCategory > 0)
    {
      selectedCategory -= 1;
    }
    if(keyCode == DOWN && selectedCategory < lines-1)
    {
      selectedCategory += 1;
    }
  }
}

void debug(String message)
{
    println("DEBUG: " + message);
}
