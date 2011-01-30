/* WARNING: No exception handling. Use with care. */

class DataLoader 
{
  private ArrayList data;
  private HashMap genreData, platformData;

  private String[] colNames;
  private String[] rowNames;

  private int colCount;
  private int rowCount;
  
  // Data specific attributes
  int minYear, maxYear;
  int numberOfMonths, numberOfYears;
  int yMax = 0;
  int[] monthlyData;
  
  String[] genres, platforms;

  DataLoader(String fileName)
  {
    String[] records = loadStrings(fileName);
    
    genres = loadStrings("genres.csv");
    platforms = loadStrings("platforms.csv");
    colNames = subset(split(records[0], ","), 1);
    rowNames = new String[records.length - 1];

    colCount = colNames.length;
    rowCount = rowNames.length;

    data = new ArrayList();

    parseData(records);
    populateGenreData();
  }

  // returns number of columns or rows 
  // (does not count row names and column names)
  public int numCols() { 
    return colCount;
  }
  public int numRows() { 
    return rowCount;
  }

  // gets a value from the data array
  public Object getValue(int row, int col) { 
    ArrayList objectRow = (ArrayList) data.get(row);
    Object objectCell = objectRow.get(col);
    return objectCell;
  }

  // returns column labels
  public String[] getLabels() 
  { 
    String[] labels = new String[colNames.length];
    arrayCopy(colNames, labels);
    return labels;
  }

  // gets individual column or row name
  public String getLabel(int col) { 
    return new String(colNames[col]);
  } 
  public String getName(int row) { 
    return new String(rowNames[row]);
  }

  // populates data array
  private void parseData(String[] records)
  {
    
    minYear = 2020;
    maxYear = 0;
    
    for(int i = 1; i < records.length; i++)
    {
      String[] entries = split(records[i], ",");
      ArrayList row = new ArrayList();
      for(int j = 1; j < colCount; j++)
      {
        Date date = new Date(entries[5]);
        row.add(date);
        row.add(entries[3]);
        row.add(entries[2]);
        minYear = min(minYear, date.year);
        maxYear = max(maxYear, date.year);
      }
      data.add(row);
      rowNames[i-1] = entries[0];
    }
    
    numberOfYears = maxYear - minYear + 1;
    numberOfMonths = numberOfYears * 12;
    monthlyData = new int[numberOfMonths];
    for(int i=0; i<numberOfMonths; i++) {monthlyData[i]=0;}
  }
  
  private void populateGenreData()
  {
    genreData = new HashMap();
    platformData = new HashMap();
    
    for(int i = 0; i < genres.length; i++)
    {
      ArrayList emptyList = new ArrayList(numberOfMonths);
      for(int j=0; j<numberOfMonths; j++){
        emptyList.add(new ArrayList());
      }
      
      String genreName = (String) genres[i];
      genreData.put(genreName,emptyList);
    }
    
    for(int i = 0; i < platforms.length; i++)
    {
      ArrayList emptyList = new ArrayList(numberOfMonths);
      for(int j=0; j<numberOfMonths; j++){
        emptyList.add(new ArrayList());
      }
      
      String platformName = (String) platforms[i];
      platformData.put(platformName,emptyList);
    }
    
    for(int i = 0; i < data.size(); i++)
    {
      ArrayList row = (ArrayList) data.get(i);
      Date date = (Date) row.get(0);
      int monthIndex = date.month + (12 * (date.year - minYear)) - 1;
      monthlyData[monthIndex] += 1;
      
      String genre = (String) row.get(1);
      ArrayList thisGenre = (ArrayList) genreData.get(genre);
      ArrayList genremonth = (ArrayList)thisGenre.get(monthIndex);
      genremonth.add(row);
      
      String platform = (String) row.get(2);
      ArrayList thisPlatform = (ArrayList) platformData.get(platform);
      ArrayList platformmonth = (ArrayList)thisPlatform.get(monthIndex);
      platformmonth.add(row);
    }
    
    for(int i = 0; i < numberOfMonths; i++)
    {
      yMax = max(yMax,monthlyData[i]);
    }
    
  }
  
}

