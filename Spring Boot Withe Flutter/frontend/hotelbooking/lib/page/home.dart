import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hotelbooking/booking/view_booking.dart';
import 'package:hotelbooking/location/location_view.dart';
import 'package:hotelbooking/page/AdminPage.dart';
import 'package:hotelbooking/page/HotelProfilePage.dart';
import 'package:hotelbooking/page/loginpage.dart';
import 'package:hotelbooking/page/registrationpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _carouselIndex = 0;
  late PageController _pageController;
  Timer? _timer;
  int _hoverIndex = -1;
  late AnimationController _animationController;

  static const List<String> _images = [
    'https://images.pexels.com/photos/14012231/pexels-photo-14012231.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
    'https://images.pexels.com/photos/9330675/pexels-photo-9330675.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
    'https://images.pexels.com/photos/12387908/pexels-photo-12387908.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
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
    {"img": "https://cdn-icons-png.freepik.com/256/11729/11729048.png?ga=GA1.1.1937478974.1725011926&semt=ais_hybrid", "title": "Location"},
    {"img": "https://cdn-icons-png.freepik.com/256/11585/11585941.png?ga=GA1.1.1937478974.1725011926&semt=ais_hybrid", "title": "Login"},
    {"img": "https://cdn-icons-png.freepik.com/256/8424/8424145.png?ga=GA1.1.1937478974.1725011926&semt=ais_hybrid", "title": "Registation"},
    {"img": "https://cdn-icons-png.freepik.com/256/5038/5038849.png?ga=GA1.1.1937478974.1725011926&semt=ais_hybrid", "title": "Booking"},
    {"img": "https://cdn-icons-png.freepik.com/256/7840/7840432.png?ga=GA1.1.1937478974.1725011926&semt=ais_hybrid", "title": "Hotel"},
    {"img": "https://cdn-icons-png.freepik.com/256/3281/3281355.png?ga=GA1.1.1937478974.1725011926&semt=ais_hybrid", "title": "Admin"}
  ];

  final List<String> cardRoutes = [
    // '/viewfirepolicy',
    // '/viewfirebill',
    // '/viewfiremoneyreceipt',
    // '/viewmarinepolicy',
    // '/viewmarinebill',
    // '/viewmarinemoneyreceipt',
    // '/viewsupport',
    // '/viewfirereports',
    // '/viewmarinereports',
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

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          _buildCarousel(),
          const SizedBox(height: 15),
          _buildGrid(),
        ],
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
              if (item["title"] == "Location") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LocationView()),
                );
              } else if (item["title"] == "Registation") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegistrationPage()),
                );
              } else if (item["title"] == "Login") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  LoginPage()),
                );
              }
              else if (item["title"] == "Booking") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  ViewBooking()),
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
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(item["img"]!, height: 50),
                  const SizedBox(height: 10),
                  Text(
                    item["title"]!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }





  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavButton(context, 'Location', Icons.location_on_sharp, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationView()));
          }),
          _buildBottomNavButton(context, 'hotel', Icons.hotel, () {
            // Navigator.push(context, MaterialPageRoute(builder: (_) => const ()));
          }),
          _buildBottomNavButton(context, 'Home', Icons.home, () {}),
          _buildBottomNavButton(context, 'Search', Icons.search, () {}),
          _buildBottomNavButton(context, 'Notifications', Icons.notifications, () {}),
        ],
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
