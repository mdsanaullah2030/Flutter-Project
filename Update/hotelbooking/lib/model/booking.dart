class Booking {
  DateTime? checkindate;
  DateTime? checkoutdate;
  int? totalprice;
  String? roomType;
  String? hotelName;
  String? userName;
  String? userEmail;

  Booking(
      {this.checkindate,
        this.checkoutdate,
        this.totalprice,
        this.roomType,
        this.hotelName,
        this.userName,
        this.userEmail});

  Booking.fromJson(Map<String, dynamic> json) {
    checkindate = json['checkindate'];
    checkoutdate = json['checkoutdate'];
    totalprice = json['totalprice'];
    roomType = json['roomType'];
    hotelName = json['hotelName'];
    userName = json['userName'];
    userEmail = json['userEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checkindate'] = this.checkindate;
    data['checkoutdate'] = this.checkoutdate;
    data['totalprice'] = this.totalprice;
    data['roomType'] = this.roomType;
    data['hotelName'] = this.hotelName;
    data['userName'] = this.userName;
    data['userEmail'] = this.userEmail;
    return data;
  }
}