import 'package:flutter/material.dart';
import 'package:hotelbooking/model/booking.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class UpdateBookingPage extends StatefulWidget {
  final Booking booking;

  const UpdateBookingPage({Key? key, required this.booking}) : super(key: key);

  @override
  State<UpdateBookingPage> createState() => _UpdateBookingPageState();
}

class _UpdateBookingPageState extends State<UpdateBookingPage> {
  late TextEditingController hotelNameController;
  late TextEditingController roomTypeController;
  late TextEditingController checkinDateController;
  late TextEditingController checkoutDateController;
  late TextEditingController totalPriceController;
  late TextEditingController userNameController;
  late TextEditingController userEmailController;

  @override
  void initState() {
    super.initState();
    hotelNameController = TextEditingController(text: widget.booking.hotelName);
    roomTypeController = TextEditingController(text: widget.booking.roomType);
    checkinDateController = TextEditingController(
      text: widget.booking.checkindate != null
          ? DateFormat('yyyy-MM-dd').format(widget.booking.checkindate!)
          : "",
    );
    checkoutDateController = TextEditingController(
      text: widget.booking.checkoutdate != null
          ? DateFormat('yyyy-MM-dd').format(widget.booking.checkoutdate!)
          : "",
    );
    totalPriceController =
        TextEditingController(text: widget.booking.totalprice.toString());
    userNameController = TextEditingController(text: widget.booking.userName);
    userEmailController = TextEditingController(text: widget.booking.userEmail);
  }

  @override
  void dispose() {
    hotelNameController.dispose();
    roomTypeController.dispose();
    checkinDateController.dispose();
    checkoutDateController.dispose();
    totalPriceController.dispose();
    userNameController.dispose();
    userEmailController.dispose();
    super.dispose();
  }

  Future<void> _savePdf() async {
    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Booking Details", style: pw.TextStyle(fontSize: 24)),
              pw.Divider(),
              pw.Text("Hotel Name: ${hotelNameController.text}"),
              pw.Text("Room Type: ${roomTypeController.text}"),
              pw.Text("Check-in Date: ${checkinDateController.text}"),
              pw.Text("Check-out Date: ${checkoutDateController.text}"),
              pw.Text("Total Price: \$${totalPriceController.text}"),
              pw.Text("User Name: ${userNameController.text}"),
              pw.Text("User Email: ${userEmailController.text}"),
            ],
          ),
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/BookingDetails.pdf";
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("PDF saved at $filePath"),
          action: SnackBarAction(
            label: "Open",
            onPressed: () => OpenFile.open(filePath),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving PDF: $e")),
      );
    }
  }

  Future<void> _printInvoice() async {
    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Invoice", style: pw.TextStyle(fontSize: 24)),
              pw.Divider(),
              pw.Text("Customer Name: ${userNameController.text}"),
              pw.Text("Customer Email: ${userEmailController.text}"),
              pw.SizedBox(height: 16),
              pw.Text("Booking Details:", style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 8),
              pw.Text("Hotel Name: ${hotelNameController.text}"),
              pw.Text("Room Type: ${roomTypeController.text}"),
              pw.Text("Check-in Date: ${checkinDateController.text}"),
              pw.Text("Check-out Date: ${checkoutDateController.text}"),
              pw.Text("Total Price: \$${totalPriceController.text}"),
            ],
          ),
        ),
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error printing invoice: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Booking")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: hotelNameController,
                decoration: const InputDecoration(labelText: "Hotel Name"),
              ),
              TextField(
                controller: roomTypeController,
                decoration: const InputDecoration(labelText: "Room Type"),
              ),
              TextField(
                controller: checkinDateController,
                decoration: const InputDecoration(labelText: "Check-in Date"),
              ),
              TextField(
                controller: checkoutDateController,
                decoration: const InputDecoration(labelText: "Check-out Date"),
              ),
              TextField(
                controller: totalPriceController,
                decoration: const InputDecoration(labelText: "Total Price"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: userNameController,
                decoration: const InputDecoration(labelText: "User Name"),
              ),
              TextField(
                controller: userEmailController,
                decoration: const InputDecoration(labelText: "User Email"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePdf,
                child: const Text("Save PDF"),
              ),
              ElevatedButton(
                onPressed: _printInvoice,
                child: const Text("Print Invoice"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
