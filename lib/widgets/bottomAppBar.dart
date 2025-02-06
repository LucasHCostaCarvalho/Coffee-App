import 'package:flutter/material.dart';
import 'package:widgets_screens/screens/gallery_screen.dart';
import 'package:widgets_screens/screens/home_page.dart';

import '../adapt/profile_screen.dart';

// Importe outras classes ou widgets necessários, como imagePickerExample

class BottomAppBarCoffeApp extends StatefulWidget {
  BottomAppBarCoffeApp();

  @override
  State<BottomAppBarCoffeApp> createState() => _BottomAppBarCoffeAppState();
}

class _BottomAppBarCoffeAppState extends State<BottomAppBarCoffeApp> {
  Color colorAppBarApp(bool x) {
    return x ? Colors.green : const Color.fromARGB(255, 18, 45, 90);
  }

  @override
  Widget build(BuildContext context) {
    bool profile_ = false;
    bool gallery_= false;
    bool home_= false;
    return BottomAppBar(
      // height: 90,
      shape: CircularNotchedRectangle(),
      notchMargin: 2.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          IconButton(
            icon: Icon(Icons.photo, color: colorAppBarApp(gallery_)),
            onPressed: () {
              gallery_ = !gallery_;
              profile_ = true;
              home_ = true;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => GalleryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.home, color: colorAppBarApp(home_)),
            padding: EdgeInsetsDirectional.only(top: 16.0),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
              setState(() {
                home_ = !home_;
                gallery_ = true;
                profile_ = true;
              });

              },
          ),
          IconButton(
            isSelected: profile_,
            icon: Icon(Icons.person, color: colorAppBarApp(profile_)),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfileScreen())); // Implemente a navegação para a tela de perfil

            },
          ),
        ],
      ),
    );
  }
}

