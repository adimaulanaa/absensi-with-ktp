class StringResources {
  StringResources._(); 

  //! Core 
  static const String nameApp = "Attendance KTP"; 
  static const String titleApp = "My Prays"; 
  static const String myName = "Another"; 
  static const String profile = "Profile"; 
  static const String welcome = "Welcome Anonim"; 
  static const String loading = "Loading..."; 

  //! Attendance 
  static const String inIdEmployee = "04438EC2D62A80"; 
  static const String inErrorKTP = "Attandance Gagal KTP tidak terdaftar";
  static const String inErrorLoc = "Attandance Gagal jarak anda terlalu jauh"; 
  static const String inErrorFace = "Attandance Gagal Wajah tidak terdeteksi (Live)"; 
  // Location Attandance 
  static const double latitude = -6.1739161; // Default latitude
  static const double longitude = 106.7859847; // Default longitude
  static const int inRangeLocationMeter = 50; 
  // Attandance IN
  static const String inTimeIn = "08:30"; 
  static const bool inUseTime = true; 
  static const String inErrorTime = "Attandance Gagal belum waktunya Absensi IN"; 
  // Attendance Out 
  static const String outTimeIn = "17:30"; 
  static const bool outUseTime = true; 
  static const String outErrorTime = "Attandance Gagal belum waktunya Absensi Out"; 
}