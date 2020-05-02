
import 'package:flutter/material.dart';

class ChartClipPath extends CustomClipper<Path>{

  Size slideBlockSize;
  Offset leftBlockOffset,rightBlockOffset;


  ChartClipPath(this.slideBlockSize, this.leftBlockOffset,
      this.rightBlockOffset);

  final double ratio =0.45;

  @override
  Path getClip(Size size) {
    debugPrint("clip size : $size");
    debugPrint("clip inner var : size- $slideBlockSize   left -  $leftBlockOffset  right - $rightBlockOffset");
    var path = Path();
    if(slideBlockSize == null || leftBlockOffset == null || rightBlockOffset == null){
      path.moveTo(0, 0);
      path.lineTo(0,size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
      path.close();
      return path;
    }

    //滑块和表为不同层，需要额外计算slideBlockSize.width * ratio
    //起始点
    path.moveTo(leftBlockOffset.dx - slideBlockSize.width * ratio, 0);
    //向下
    path.lineTo(leftBlockOffset.dx - slideBlockSize.width * ratio, leftBlockOffset.dy);
    //向右
    path.lineTo(rightBlockOffset.dx - slideBlockSize.width * ratio, rightBlockOffset.dy);
    //向上
    path.lineTo(rightBlockOffset.dx - slideBlockSize.width * ratio, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {

    return true;
  }

}