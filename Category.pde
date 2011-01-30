/* CS 486: Information Visualization
 * Final Visualization Project
 *
 * Rodrigo Thauby
 */

public class Category {

  int _width = 400;
  int _height = 768;

  CategoryApplet applet;
  CategoryFrame frame;

  public Category(String[] list) {
    frame = new CategoryFrame(_width,_height);
    applet = new CategoryApplet(list,_width,_height);

    frame.add(applet);
    applet.init();
    frame.show();
  }
}

public class CategoryFrame extends Frame {

  public CategoryFrame(int width, int height) {
    setBounds(0,0,width,height+25);
  }
}

public class CategoryApplet extends PApplet {
  
  int Y_AXIS = 1;
  int X_AXIS = 2;
  int LINE_HEIGHT = 12;
  int TEXT_SIZE = 9;
  int ITEMS_PER_COLUMN = 60;

  int plotX1, plotY1;  // upper-left corner of plot area
  int plotX2, plotY2;  // lower-right corner of plot area
  int desiredWidth, desiredHeight;
  String[] categories;
  color colorA = color(247,182,8);
  color colorB = color(255,255,255);
  int legendMin, legendMax, legendMaxTwo;

  public CategoryApplet(String[] list, int _width, int _height) {
    desiredWidth = _width;
    desiredHeight = _height;
    categories = list;
  }
  
  public void setup() {
    debug("Initializing category window...");

    size(desiredWidth, desiredHeight);
    smooth();

    // initialize plot area
    plotX1 = 60;
    plotY1 = 40;
    plotX2 = width - plotX1;
    plotY2 = height - plotY1;

    
  }

  public void draw() {
    background(230);
    drawCategories();
    drawLegend();
  }
  
  void drawLegend(){
    noFill();
    stroke(0);
    strokeWeight(1);
    //setGradient(x, y, w, h, c1, c2, Y_AXIS);
    
    if(categories.length > ITEMS_PER_COLUMN){
      
      float lerpIndex = parseFloat(ITEMS_PER_COLUMN) / parseFloat(categories.length);
      color intermediateColor = lerpColor(colorA,colorB,lerpIndex);
      
      setGradient(12, legendMin, 15, legendMax - legendMin, colorA, intermediateColor, Y_AXIS);
      rect(12, legendMin, 15, legendMax - legendMin);
      
      setGradient(172, legendMin, 15, legendMaxTwo - legendMin, intermediateColor, colorB, Y_AXIS);
      rect(172, legendMin, 15, legendMaxTwo - legendMin);
      
    } else {
      
      setGradient(12, legendMin, 15, legendMax - legendMin, colorA, colorB, Y_AXIS);
      rect(12, legendMin, 15, legendMax - legendMin);
    
    }
    
    noStroke();
  }
  
  void drawCategories(){
    
    int displace = 1;
    fill(0);
    textSize(12);
    if(categoryId == 1)text("GENRES", 12, 8);
    else if(categoryId == 2)text("PLATFORMS", 12, 8);
    
    for(int i=0; i<categories.length; i++){
      if(i >= ITEMS_PER_COLUMN) displace = 5; 
      textAlign(LEFT, TOP);
      if(highlighting && selectedCategory == i) fill(255,0,0);
      else fill(100);
      
      textSize(TEXT_SIZE);
      text(categories[i], displace * 40, ((i % ITEMS_PER_COLUMN) * LINE_HEIGHT) + 30);
      
      if(i==0){
        legendMin = (i * LINE_HEIGHT) + 30;
      }
      if(i < ITEMS_PER_COLUMN){
        legendMax = ((i + 1) * LINE_HEIGHT) + 30;
      } else {
        legendMaxTwo = (((i % ITEMS_PER_COLUMN) + 1) * LINE_HEIGHT) + 30;
      }
      
    }
    
  }
  
  void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ){
  // calculate differences between color components 
  float deltaR = red(c2)-red(c1);
  float deltaG = green(c2)-green(c1);
  float deltaB = blue(c2)-blue(c1);

  // choose axis
  if(axis == Y_AXIS){
    /*nested for loops set pixels
     in a basic table structure */
    // column
    for (int i=x; i<=(x+w); i++){
      // row
      for (int j = y; j<=(y+h); j++){
        color c = color(
        (red(c1)+(j-y)*(deltaR/h)),
        (green(c1)+(j-y)*(deltaG/h)),
        (blue(c1)+(j-y)*(deltaB/h)) 
          );
        set(i, j, c);
      }
    }  
  }  
  else if(axis == X_AXIS){
    // column 
    for (int i=y; i<=(y+h); i++){
      // row
      for (int j = x; j<=(x+w); j++){
        color c = color(
        (red(c1)+(j-x)*(deltaR/h)),
        (green(c1)+(j-x)*(deltaG/h)),
        (blue(c1)+(j-x)*(deltaB/h)) 
          );
        set(j, i, c);
      }
    }  
  }
}
  
}
