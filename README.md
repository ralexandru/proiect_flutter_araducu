# Proiect Flutter - Dezvoltare aplicatii mobile
Backend:
API endpoints were written using C#, ASP.NET.

Database:
Data is being stored in an SQL Server database.

Frontend:
Flutter was used to retrieve data from API endpoints and display it onto the dashboard.

## Things worth mentioning:
1. Lib contains 2 directories and some dart classes.
   a. Classes directory contains classes translated from C# to Flutter so there will be no conflict in logic when retrieving the data.
   b. Common contains a .dart file called utilities.dart which contains some custom widgets I created.
   c. Files thar are stored directly under lib directory contains UI pages.

Application was tested on a real Android device using adb.
In case that you want to set up adb:
1. Enable debug through WiFi from Phone developer settings.
2. Open cmd on Windows and execute:
  a. adb start-server
  b. adb connect <phone_ip>:<port>
  c. adb reverse tcp:<port> tcp:<port>
