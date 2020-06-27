library numeric_keyboard;

import 'package:flutter/material.dart';

typedef KeyboardTapCallback = void Function(String text);

class NumericKeyboard extends StatefulWidget {
  final Color textColor;
  final Icon rightIcon;
  final Function() rightButtonFn;
  final Icon leftIcon;
  final Function() leftButtonFn;
  final KeyboardTapCallback onKeyboardTap;
  final MainAxisAlignment mainAxisAlignment;

  NumericKeyboard({Key key, @required this.onKeyboardTap, this.textColor = Colors.black, this.rightButtonFn, this.rightIcon, this.leftButtonFn, this.leftIcon, this.mainAxisAlignment = MainAxisAlignment.spaceEvenly}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NumericKeyboardState();
  }
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _calcButton('1'),
              _calcButton('2'),
              _calcButton('3'),
            ],
          ),
          Row(
            children: <Widget>[
              _calcButton('4'),
              _calcButton('5'),
              _calcButton('6'),
            ],
          ),
          Row(
            children: <Widget>[
              _calcButton('7'),
              _calcButton('8'),
              _calcButton('9'),
            ],
          ),
          Row(
            children: <Widget>[
              InkWell(borderRadius: BorderRadius.circular(45), onTap: widget.leftButtonFn, child: Container(alignment: Alignment.center, width: MediaQuery.of(context).size.width * 0.333333, height: 50, child: widget.leftIcon)),
              _calcButton('0'),
              Material(color: Colors.white,child: InkWell(borderRadius: BorderRadius.circular(45), onTap: widget.rightButtonFn, child: Container(alignment: Alignment.center, width: MediaQuery.of(context).size.width * 0.333333, height: 60, child: widget.rightIcon)))
            ],
          ),
        ],
      ),
    );
  }

  Widget _calcButton(String value) {
    return Material(
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(45),
          onTap: () {
            widget.onKeyboardTap(value);
          },
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.333333,
            height: 60,
            child: Text(
              value,
              style: TextStyle(fontSize: 26,  color: widget.textColor),
            ),
          ),
        ));
  }
}
