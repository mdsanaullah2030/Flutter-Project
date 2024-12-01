import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hotelbooking/booking/view_booking.dart';
import 'package:hotelbooking/hotel/AddHotelPage.dart';
import 'package:hotelbooking/location/AddLocation.dart';
import 'package:hotelbooking/location/UpdateLocation.dart';
import 'package:hotelbooking/location/addshow.dart';
import 'package:hotelbooking/location/location_view.dart';
import 'package:hotelbooking/page/AdminPage.dart';
import 'package:hotelbooking/page/HotelProfilePage.dart';
import 'package:hotelbooking/page/home.dart';
import 'package:hotelbooking/page/loginpage.dart';
import 'package:hotelbooking/page/registrationpage.dart';
import 'package:hotelbooking/room/addRoom.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AdminPage> with SingleTickerProviderStateMixin {
  int _carouselIndex = 0;
  late PageController _pageController;
  Timer? _timer;
  int _hoverIndex = -1;
  late AnimationController _animationController;

  static const List<String> _images = [
    'https://media.istockphoto.com/id/636484522/photo/hotel-resort-swimming-pool.jpg?s=612x612&w=0&k=20&c=ET-8reopQEIhH4YYee6tqlFpfKEg19oLRRCJX3-56rs=',
    'https://media.istockphoto.com/id/937993150/photo/ipoh-station.jpg?s=612x612&w=0&k=20&c=ytlQI6S-KDzZJ4fE3-hH2iL3E3xLHzb620nt5JQaG9Y=',
    'https://media.istockphoto.com/id/598696388/photo/emirates-palace-abu-dhabi-united-arab-emirates.jpg?s=612x612&w=0&k=20&c=Hv29s0zkDci83bKhMLe7PR7TeR8GVdBiIudt_ptraS0=',
  ];

  static const List<String> _texts = [
    "একমাত্র ভ্রমনেই রয়েছে আনন্দ আর অভিজ্ঞতার সমন্বয়",
    "ভ্রমন মানুষের জ্ঞানের পরিধি বৃদ্ধি করে",
    "কুসংস্কার, গোঁড়ামি এবং সংকীর্ণতার জন্য ভ্রমণ হলো মহা ঔষধ",
  ];

  static const List<Color> _colors = [
    Colors.purple,
    Colors.green,
    Colors.lime,
  ];

  final List<Map<String, String>> myItems = [
    {"img": "https://cdn-icons-png.freepik.com/256/11729/11729048.png?ga=GA1.1.1937478974.1725011926&semt=ais_hybrid", "title": "Add Location"},
    {"img": "https://cdn-icons-png.freepik.com/256/13086/13086265.png?ga=GA1.1.897004978.1724843830&semt=ais_hybrid", "title": "Add Hotel"},
    {"img": "https://cdn-icons-png.freepik.com/256/8507/8507773.png?ga=GA1.1.897004978.1724843830&semt=ais_hybrid", "title": "Add Room"},
    {"img": "https://cdn-icons-png.freepik.com/256/5038/5038849.png?ga=GA1.1.1937478974.1725011926&semt=ais_hybrid", "title": "Update Location"},
    {"img": "https://cdn-icons-png.freepik.com/256/7840/7840432.png?ga=GA1.1.1937478974.1725011926&semt=ais_hybrid", "title": "Update Hotel"},
    {"img": "https://cdn-icons-png.freepik.com/256/3281/3281355.png?ga=GA1.1.1937478974.1725011926&semt=ais_hybrid", "title": "Update Room"},

  ];

  final List<String> cardRoutes = [

  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPageChange();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.95,
      upperBound: 1.05,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startAutoPageChange() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _carouselIndex = (_carouselIndex + 1) % _images.length;
      });
      _pageController.animateToPage(
        _carouselIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'হোটেল বুকিং ডোট কোম পক্ষ  হতে আপনাকে স্বাগত',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text('Welcome to HotelBooking.com',
              style: TextStyle(fontSize: 12 ,fontWeight: FontWeight.bold)),
        ],
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.blue, Colors.lightGreen, Colors.teal],
          ),
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://avatars.githubusercontent.com/u/158471899?v=4',
            ),
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
    );
  }


  //Drawer use//

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.greenAccent, Colors.orangeAccent],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/158471899?v=4'),
                ),
                const SizedBox(height: 10),
                const Text('Welcome, User!', style: TextStyle(color: Colors.white, fontSize: 20)),
                const Text('HotelBooking@gmail.com', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          _buildDrawerItem(context, Icons.person, 'Profile', '/profile'),
          _buildDrawerItem(context, Icons.contact_mail, 'Contact Us', '/contact'),
          _buildDrawerItem(context, Icons.location_on_sharp, 'Location', '/Location'),
          _buildDrawerItem(context, Icons.hotel, 'Hotel', '/Hotel'),
          const Divider(),
          _buildDrawerItem(context, Icons.login, 'Login', '/LoginPage'),
          _buildDrawerItem(context, Icons.logout, 'Logout', '/login'),
        ],
      ),
    );
  }






  Widget _buildDrawerItem(BuildContext context, IconData icon, String label, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }

//Body BackRaont//

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.lightGreen[300]!, // First color
            Colors.blue[200]!,
            Colors.indigo[200]!,
            Colors.red[200]!, // Second color
          ],
          begin: Alignment.topLeft, // Starting point of the gradient
          end: Alignment.bottomRight, // Ending point of the gradient
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _buildCarousel(),
            const SizedBox(height: 15),
            _buildGrid(),
          ],
        ),
      ),
    );
  }


  Widget _buildCarousel() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: SizedBox(
        height: 160,
        child: PageView.builder(
          controller: _pageController,
          itemCount: _images.length,
          onPageChanged: (index) {
            setState(() {
              _carouselIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Container(
              color: _colors[index],
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(_images[index], fit: BoxFit.cover),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Text(
                      _texts[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        backgroundColor: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.2,
        ),
        itemCount: myItems.length,
        itemBuilder: (context, index) {
          final item = myItems[index];
          return GestureDetector(
            onTap: () {
              if (item["title"] == "Add Location") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddLocationPage()),
                );
              } else if (item["title"] == "Add Hotel") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddHotelPage()),
                );
              } else if (item["title"] == "Add Room") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  AddRoomPage()),
                );
              }
              else if (item["title"] == "Update Location") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  LocationViewAdd()),
                );
              }

              else if (item["title"] == "Hotel") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  HotelProfilePage(hotelName: "", hotelImageUrl: "", address: "", rating: "", minPrice: 2, maxPrice: 2)),
                );
              }

              else if (item["title"] == "Admin") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  AdminPage()),
                );
              }

            },

            //Cade view//
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.lightGreen[300]!, // First color
                    Colors.blue[200]!,
                    Colors.indigo[200]!,
                    Colors.red[200]!, // Second color
                  ],
                  begin: Alignment.topLeft, // Start of the gradient
                  end: Alignment.bottomRight, // End of the gradient
                ),
                borderRadius: BorderRadius.circular(15), // Match the Card's border radius
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.transparent, // Ensure the Card doesn't overwrite the gradient
                elevation: 5, // Optional: Add some elevation for shadow
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(item["img"]!, height: 50),
                    const SizedBox(height: 10),
                    Text(
                      item["title"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),


          );
        },
      ),
    );
  }


//BottomAppBar //


  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.lightGreen[50]!, // First color
            Colors.blue[50]!,
            Colors.indigo[50]!,
            Colors.red[50]!, // Second color
          ],
          begin: Alignment.topLeft, // Gradient starts from top-left
          end: Alignment.bottomRight, // Gradient ends at bottom-right
        ),
      ),
      child: BottomAppBar(
        elevation: 0, // Set to 0 to blend with gradient background
        color: Colors.transparent, // Make the BottomAppBar background transparent
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavButton(context, 'Location', Icons.location_on_sharp, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationView()));
            }),
            _buildBottomNavButton(context, 'Login', Icons.login, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
            }),
            _buildBottomNavButton(context, 'Home', Icons.home, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
            }),
            _buildBottomNavButton(context, 'Search', Icons.search, () {}),
            _buildBottomNavButton(context, 'Notifications', Icons.notifications, () {}),
          ],
        ),
      ),
    );
  }


  Widget _buildBottomNavButton(
      BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        onEnter: (_) => setState(() {
          _hoverIndex = label.hashCode;  // Use a unique hash for each label
        }),
        onExit: (_) => setState(() {
          _hoverIndex = -1;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..scale(_hoverIndex == label.hashCode ? 1.2 : 1.0), // Scale on hover
          decoration: BoxDecoration(
            boxShadow: [
              if (_hoverIndex == label.hashCode)
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.2), // Light blue shadow on hover
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: _hoverIndex == label.hashCode ? Colors.green : Colors.blue,
                size: _hoverIndex == label.hashCode ? 30 : 24, // Increase icon size on hover
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _hoverIndex == label.hashCode ? Colors.pinkAccent : Colors.blue,
                  fontStyle: _hoverIndex == label.hashCode ? FontStyle.italic : FontStyle.normal, // Optional italic on hover
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
