class CurrentUser {
  static String? id;
  static String? firstName;
  static String? lastName;
  static String? email;
  static String? password;
  static String? location;
  static String? address = "";
  static String? mobile;
  static String? image;
  static String? approvedStatus;
  static int? subscription;
  static String? userType;
  static String isOnline = "0";
  static double lat = 37.42796133580664;
  static double lng = -122.085749655962;

  CurrentUser();

  CurrentUser shared = CurrentUser();
}
