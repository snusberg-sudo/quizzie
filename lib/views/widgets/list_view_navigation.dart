import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListViewNavigation extends StatelessWidget {
  const ListViewNavigation({super.key, required this.widgetsList});

  final List<Map<String, dynamic>> widgetsList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: widgetsList.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.indigoAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
              side: BorderSide(
                color: Colors.black87,
                width: 1.25
              )
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
              splashColor: Colors.transparent,
              onTap: widgetsList.elementAt(index)['action'],
              leading: CircleAvatar(
                radius: 23.0,
                backgroundColor: Colors.grey.shade100.withValues(alpha: 0.3),
                child: FaIcon(
                  widgetsList.elementAt(index)['icon'],
                  color: Colors.white,
                ),
              ),
              title: Text(
                widgetsList.elementAt(index)['text'],
                style: TextStyle(fontWeight: FontWeight.w600, color: widgetsList.elementAt(index)['textColor']),
              ),
              trailing: widgetsList.elementAt(index)['trailingAction'] != null ? IconButton(
                onPressed: widgetsList.elementAt(index)['trailingAction'],
                icon: FaIcon(FontAwesomeIcons.chevronRight, size: 16.0, color: Colors.grey.shade100,),
              ) : null,
            ),
          );
        },
      ),
    );
  }
}
