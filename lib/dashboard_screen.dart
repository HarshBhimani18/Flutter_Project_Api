import 'package:flutter/material.dart';
import 'package:flutter_project_api/about_page.dart';
import 'package:flutter_project_api/add_edit_user_screen.dart';
import 'package:flutter_project_api/list_view.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Container(),
    UserListPage(),
    UserEntryPage(),
    UserListPage(isFavourite: true),
    AboutPage()
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget MenuButtonView(String label, IconData iconName, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        shadowColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconName, size: 50, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.robotoSlab(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: _selectedIndex == 0 ? AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          "Matrimonial",
          style: GoogleFonts.pacifico(fontSize: 33, color: Colors.white),
        ),
      ) : null ,
      body: _selectedIndex == 0 ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          children: [
            MenuButtonView("Add User", Icons.person_add, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserEntryPage(),
                ),
              );
            }),
            MenuButtonView("User List", Icons.list, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserListPage(),
                ),
              );
            }),
            MenuButtonView("Favorites", Icons.favorite, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserListPage(isFavourite: true)
                ),
              );
            }),
            MenuButtonView("About Us", Icons.info, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            }),
          ],
        ),
      ) : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home,size: 30,),
              backgroundColor: Colors.pink,
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list,size: 30,),
              backgroundColor: Colors.pink,
              label: "list"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add,size: 30,),
              backgroundColor: Colors.pink,
              label: "Add"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite,size: 30,),
              backgroundColor: Colors.pink,
              label: "Favorite"),
          BottomNavigationBarItem(
              icon: Icon(Icons.info,size: 30,),
              backgroundColor: Colors.pink,
              label: "About"),


        ],
        backgroundColor: Colors.pink[50],
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        iconSize: 23,
      ),
    );
  }
}
