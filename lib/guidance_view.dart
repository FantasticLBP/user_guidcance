import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import './guidance_info.dart';

class GuidanceView extends StatelessWidget {
  final GuidanceContextInfo contextModel;
  final Function() handleNextStep;

  GuidanceView({this.contextModel, this.handleNextStep})
    : assert(contextModel != null && handleNextStep != null); 

  void handleClickNextButton () {
    handleNextStep();
  }

  Widget showContainerPanel () {
    if (contextModel.position == GuidancePosition.bottomLeft || contextModel.position == GuidancePosition.bottomRight) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: (contextModel.screenWidth > 375) ?  ((contextModel.position == GuidancePosition.bottomLeft || contextModel.position == GuidancePosition.bottomRight)  ? CrossAxisAlignment.start : CrossAxisAlignment.end) : CrossAxisAlignment.start,
        children: <Widget>[
          showPanel(),
          Container(
            child: contextModel.arrowImage,
            width: 30,
            height: 70,
            margin: EdgeInsets.only(left: contextModel.arrowRect.left),
          ),
        ]
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: (contextModel.screenWidth > 375) ? ((contextModel.position == GuidancePosition.topLeft)  ? CrossAxisAlignment.start : CrossAxisAlignment.end) : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: contextModel.arrowImage,
            width: 30,
            height: 70,
            margin: EdgeInsets.only(left: contextModel.arrowRect.left),
          ),
          showPanel()
        ]
      );
    }
  }

  Widget showPanel () {
    List<Container> children = List();
    if (contextModel.title != null && contextModel.title.isNotEmpty) {
      children.add(
        Container(
          child: Text(
            contextModel.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
        )
      );
    }
    if (contextModel.context != null && contextModel.context.isNotEmpty) {
      children.add(
        Container(
          child: Text(
            contextModel.context ?? '',
            softWrap: true,
            maxLines: 2,
            textAlign: (contextModel.position == GuidancePosition.bottomRight || contextModel.position == GuidancePosition.topRight) ? TextAlign.right : TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            )
          ),
          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
          width: 326,
        )
      );
    }
    children.add(Container(
      child: FlatButton(
        onPressed: handleClickNextButton, 
        color: Colors.white,
        child: Text(contextModel.buttonText, style: TextStyle(fontSize: 14)), 
        textColor: Color.fromRGBO(50, 50, 51, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2)
        ),
      ),
      width: 128,
      height: 40,
      margin: EdgeInsets.only(left: (contextModel.title != null && contextModel.title.isNotEmpty) ? 0 : contextModel.contentRect.width/2 - contextModel.buttonWidth/2),
    )
  );

    return Container(
      width: contextModel.contextWidth,
      margin: EdgeInsets.only(left: contextModel.contentRect.left > 0 ? contextModel.contentRect.left : 0 ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: (contextModel.position == GuidancePosition.bottomRight || contextModel.position == GuidancePosition.topRight) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: children,
      )
    );
  }

  @override
  Widget build (BuildContext context) {
    return Container(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            showContainerPanel()
          ],
        ),
        width: contextModel.screenWidth,
      ),
    );
  }
}
