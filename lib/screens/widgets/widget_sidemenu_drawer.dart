import 'package:flutter/material.dart';
import 'package:playinsample/constants/constant_colors.dart';

class WidgetSidemenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: (ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: color_charcoal_blue),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('검사기록'),
            onTap: (){},
          ),
          ListTile(
            title: Text('도움말'),
            onTap: (){},
          ),
        ],
      )),
    );
  }
}
