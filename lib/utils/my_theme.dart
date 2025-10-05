import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_app/utils/icon_btn.dart';

ThemeData MyTheme(){
  return ThemeData(
    fontFamily: 'Nunito',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white,fontSize: 23),
      bodySmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
    useMaterial3: true, // important for M3 theming
  );
}


AppBar animatedAppBar(bool _isSearching, TextEditingController _searchController, Function _onSearchChanged,VoidCallback _stopSearch,VoidCallback _startSearch){
  return AppBar(
  backgroundColor: mainColor,
  elevation: 0,
  title: AnimatedSwitcher(
  duration: const Duration(milliseconds: 250),
  transitionBuilder: (child, animation) =>
  SizeTransition(sizeFactor: animation, axis: Axis.horizontal, child: child),
  child: _isSearching
  ? TextField(
  key: const ValueKey('searchField'),
  controller: _searchController,
  autofocus: true,
  style: const TextStyle(color: Colors.white),
  decoration: const InputDecoration(
  hintText: 'Search notes...',
  hintStyle: TextStyle(color: Colors.white54),
  border: InputBorder.none,
  ),
  onChanged:(value) =>  _onSearchChanged(value),
  )
      : const Text(
  'My Notes',
  key: ValueKey('titleText'),
  style: TextStyle(color: Colors.white),
  ),
  ),
  actions: [
  IconButton(
  icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
  onPressed: () {
  if (_isSearching) {
  _stopSearch();
  } else {
  _startSearch();
  }
  },
  ),
  ],
  );

}

AppBar MyAppBar(){
  return AppBar(
    backgroundColor:Color(0xFF252525) ,
    foregroundColor: Colors.white,
    title:Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Notes",style: TextStyle(fontSize: 35,),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconBtn(icon: Icon(Icons.search),iconBtnFun: (){}),
            SizedBox(
              width: 21,
            ),
            IconBtn(icon: Icon(Icons.info_outline),iconBtnFun: (){})

          ],
        )
        ],
    ),);
}

var mainColor=Color(0xFF252525);
var greyColor= Color(0xFF9A9A9A);
var mediamGreyColor=Color(0xFF606060);
var TransparentGreyColor=Color(0xFF3B3B3B);
var greenColor=Color(0xFF30BE71);
var redColor= Color(0xFFFF0000);

Color randomColor() {
  final Random random = Random();

  while (true) {
    final color = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );

    // Check brightness
    // computeLuminance() returns value between 0 (dark) and 1 (bright)
    if (color.computeLuminance() > 0.2) {
      return color; // accept only if not too dark
    }
  }
}
