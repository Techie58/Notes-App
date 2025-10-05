
import 'package:flutter/material.dart';

import 'my_theme.dart';

class IconBtn extends StatelessWidget{

  final Widget icon;
  VoidCallback? iconBtnFun;


  IconBtn({required this.icon, required this.iconBtnFun});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(15),
        color: TransparentGreyColor,
      ),
      child: IconButton(onPressed: iconBtnFun, icon: icon,color: Colors.white,),
    );
  }


}