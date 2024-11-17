import 'dart:convert';

import 'package:hotelbooking/model/room.dart';

class Booking {
  DateTime? checkindate;
  DateTime? checkoutdate;
  int? totalprice;
  String? roomType;
  String? hotelName;
  String? userName;
  String? userEmail;
  Room? room;

  Booking({
    this.checkindate,
    this.checkoutdate,
    this.totalprice,
    this.roomType,
    this.hotelName,
    this.userName,
    this.userEmail,
    this.room,
  });

  Booking.fromJson(Map<String, dynamic> json) {
    checkindate = json['checkindate'] != null
        ? DateTime.parse(json['checkindate'])
        : null;
    checkoutdate = json['checkoutdate'] != null
        ? DateTime.parse(json['checkoutdate'])
        : null;
    totalprice = json['totalprice'];
    roomType = json['roomType'];
    hotelName = json['hotelName'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    room = json['room'] != null ? Room.fromJson(jsonDecode(json['room'])) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['checkindate'] =
    checkindate != null ? checkindate!.toIso8601String() : null;
    data['checkoutdate'] =
    checkoutdate != null ? checkoutdate!.toIso8601String() : null;
    data['totalprice'] = totalprice;
    data['roomType'] = roomType;
    data['hotelName'] = hotelName;
    data['userName'] = userName;
    data['userEmail'] = userEmail;
    data['room'] = room?.toJson();
    return data;
  }
}
