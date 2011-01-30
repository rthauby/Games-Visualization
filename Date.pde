public class Date {
  
  int day, month, year;
  
  public Date(String dateString) {
    String[] entries = split(dateString, "/");
    month = parseInt(entries[0]);
    day = parseInt(entries[1]);
    year = parseInt(entries[2]);
  }
  
}
