import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  // Sample image URLs
  final List<String> imageUrls = [
    'https://cdn-icons-png.freepik.com/256/13026/13026672.png?ga=GA1.1.897004978.1724843830&semt=ais_hybrid',
    'https://cdn-icons-png.freepik.com/256/2250/2250142.png?ga=GA1.1.897004978.1724843830&semt=ais_hybrid',
    'https://cdn-icons-png.freepik.com/256/15532/15532851.png?ga=GA1.1.897004978.1724843830&semt=ais_hybrid',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjuT0CU-25imSzGacX-954Q7fptJGnNjx0kQ&s',
    'https://cdn.hugeicons.com/icons/shopping-cart-check-in-01-duotone-rounded.svg',
    'https://images.pexels.com/photos/338504/pexels-photo-338504.jpeg?auto=compress&cs=tinysrgb&w=400',
  ];

  // List of widgets for each tab
  final List<Widget> _tabs = [
    Center(child: Text('Home')),
    Center(child: Text('Search')),
    Center(child: Text('Favorites')),
    Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Card View'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.blueGrey[50],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 4,
          ),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Set a fixed height for the image to control its size
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      imageUrls[index],
                      height: 100, // Set a fixed height for the image
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Location ${index + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
