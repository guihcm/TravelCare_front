// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_final_fields, must_be_immutable, no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';

class MyNavBar extends StatelessWidget {
  int _selectedIndex = 0;
  ValueChanged<int> _selectPage;
  MyNavBar(this._selectedIndex, this._selectPage, {super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      backgroundColor: Colors.blue,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      items: [
        //Home
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          label: 'Home',
        ),
        //Viagem
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.directions_car,
            color: Colors.white,
          ),
          label: 'Viagem',
        ),
         //Notificação
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          label: 'Notificação',
        ),
        //Perfil
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: Colors.white,
          ),
          label: 'Perfil',
        ),
      ],
      onTap: _selectPage,
    );
  }
}
