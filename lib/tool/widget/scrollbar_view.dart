import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ScrollbarViewDir {
  vertical,
  transverse,
}

class ScrollbarView extends StatelessWidget {
  final Color? backgroundColor;
  final Color? sliderColor;
  final double start;
  final double showLength;
  final ScrollbarViewDir scrollbarViewDir;

   ScrollbarView({
    Key? key,
    required this.start,
    required this.showLength,
    this.sliderColor,
    this.backgroundColor,
    this.scrollbarViewDir = ScrollbarViewDir.vertical,
  }) : super(key: key){
     assert(start>=0.0&&start<=1.0);
     assert(showLength>=0.0&&showLength<=1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color.fromRGBO(140, 140, 140, 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: LayoutBuilder(
        builder: (bc, con) {
          Widget resultBar;

          if (scrollbarViewDir == ScrollbarViewDir.vertical) {
            resultBar = Positioned(
              right: 0,
              left: 0,
              top: con.maxHeight * start,
              child: Container(
                height: con.maxHeight * showLength,
                decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, 0), blurRadius: 1)],
                  color: sliderColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          } else {
            resultBar = Positioned(
              top: 0,
              bottom: 0,
              left: con.maxWidth * start,
              child: Container(
                width: con.maxWidth * showLength,
                decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, 0), blurRadius: 1)],
                  color: sliderColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }

          return Stack(
            clipBehavior: Clip.none,
            children: [
              resultBar,
            ],
          );
        },
      ),
    );
  }
}
