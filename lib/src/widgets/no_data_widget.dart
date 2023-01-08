//WIDGETS PERSONALIZADOS...

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  
  String text = '';

  NoDataWidget({this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/no_items.png',
            height: 400,
            width: 400,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}