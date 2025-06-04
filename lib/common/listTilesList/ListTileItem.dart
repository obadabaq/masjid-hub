import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListTileItem extends StatelessWidget {
  const ListTileItem({Key? key,
    required this.title,
    required this.onSwitchOn,
    required this.onSwitchOff,
    required this.isLastItem,
    required this.tileValue,
  }) : super(key: key);

  final String title;
  final Function onSwitchOn;
  final Function onSwitchOff;
  final bool isLastItem;
  final bool tileValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => tileValue  == true ? onSwitchOff() : onSwitchOn(),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 40),
                child: ListTile(
                  title: Text(title),
                  trailing: CustomSwitch(value: tileValue, onChanged: (value){
                    if(value){
                      onSwitchOn();
                    }else{
                      onSwitchOff();
                    }
                  })
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 60.0,
        height: 34.0,
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: widget.value ? Color(0xFF00ACC1) : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: widget.value
                  ? Colors.transparent
                  : Color(0xFF00ACC1).withOpacity(0.5),
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 28.0,
              height: 28.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.value
                        ? Colors.transparent
                        : Color(0xFF00ACC1).withOpacity(0.3),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
