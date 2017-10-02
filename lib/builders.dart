import 'package:flutter/material.dart';

Widget build_flex_center(Widget child, {EdgeInsets padding = null, int flex = 1}) {

    if (padding == null) 
      padding = new EdgeInsets.all (0.0);


    return new Flexible (
      child: new Center (
        child: new Padding (
          child: child, 
          padding: padding,
        )
      ),
      flex: flex,
    );
}



