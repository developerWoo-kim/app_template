import 'package:app_template/common/utils/dialog_util.dart';
import 'package:app_template/template/bottom_navigation_bar/bottom_navigation_bar_screen.dart';
import 'package:flutter/material.dart';

class TemplateGuideScreen extends StatelessWidget {
  const TemplateGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text('Dialog',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),],),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    DialogUtil.showSingleConfirm(context,
                      content: 'showNoTitleSingleConfirm',
                      confirmText: '확인',
                      confirmCallBack: (){Navigator.of(context).pop();},
                    );
                  },
                  child: Text('No Title + Single Confirm'),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    DialogUtil.showSingleConfirm(context,
                      title: 'showTitleSingleConfirm',
                      content: 'showTitleSingleConfirm',
                      confirmText: '확인',
                      confirmCallBack: (){Navigator.of(context).pop();},
                    );
                  },
                  child: Text('Title + Single Confirm'),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    DialogUtil.showDoubleConfirm(context,
                      content: 'noTitleDoubleConfirm',
                      confirmText: '확인',
                      cancelText: '취소',
                      confirmCallBack: (){},
                      cancelCallBack: (){Navigator.of(context).pop();}
                    );
                  },
                  child: Text('No Title + Double Confirm'),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    DialogUtil.showDoubleConfirm(context,
                        title: 'ShowTitleDoubleConfirm',
                        content: 'TitleDoubleConfirm',
                        confirmText: '확인',
                        cancelText: '취소',
                        confirmCallBack: (){},
                        cancelCallBack: (){Navigator.of(context).pop();}
                    );
                  },
                  child: Text('Title + Double Confirm'),
                ),
              )
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text('BottomNavigationBar',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500),),],),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BottomNavigationBarScreen(),
                      ),
                    );
                  },
                  child: Text('Basic BottomNavigationBar'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
