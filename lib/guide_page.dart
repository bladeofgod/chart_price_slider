


import 'package:chart_price_slider/demo/chart/paint_chart.dart';
import 'package:flutter/material.dart';

import 'demo/demo_page.dart';

class GuidePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GuidePageState();
  }

}

class GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
              return DemoPage();
            }));
          },child: Text("demo page"),),
          SizedBox(height: 30.0,),
          RaisedButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
              return PaintChart();
            }));
          },child: Text("paint chart page"),),
        ],
      ),
    );
  }
}