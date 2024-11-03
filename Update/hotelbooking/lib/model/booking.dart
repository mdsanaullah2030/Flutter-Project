class Booking {
  int? id; // Make id nullable
  DateTime checkindate;
  DateTime checkoutdate;
  int totalprice;
  String roomType;
  String hotelName;
  String userName;
  String userEmail;

  Booking({
    this.id, // id is now optional
    required this.checkindate,
    required this.checkoutdate,
    required this.totalprice,
    required this.roomType,
    required this.hotelName,
    required this.userName,
    required this.userEmail,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] != null ? json['id'] as int : null, // Safely handle null
      checkindate: DateTime.parse(json['checkindate']),
      checkoutdate: DateTime.parse(json['checkoutdate']),
      totalprice: json['totalprice'],
      roomType: json['roomType'],
      hotelName: json['hotelName'],
      userName: json['userName'],
      userEmail: json['userEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // id can be null
      'checkindate': checkindate,
      'checkoutdate': checkoutdate,
      'totalprice': totalprice,
      'roomType': roomType,
      'hotelName': hotelName,
      'userName': userName,
      'userEmail': userEmail,
    };
  }
}
