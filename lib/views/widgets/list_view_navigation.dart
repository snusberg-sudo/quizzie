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
          return ListTile(
            splashColor: Colors.transparent,
            
            onTap: widgetsList.elementAt(index)['action'],
            leading: CircleAvatar(
              radius: 23.0,
              backgroundColor: Colors.blueAccent.shade700.withValues(
                alpha: 0.2,
              ),
              child: FaIcon(
                widgetsList.elementAt(index)['icon'],
                color: Colors.indigoAccent.shade400,
              ),
            ),
            title: Text(
              widgetsList.elementAt(index)['text'],
              style: TextStyle(fontWeight: FontWeight.w600, color: widgetsList.elementAt(index)['textColor']),
            ),
            trailing: widgetsList.elementAt(index)['trailingAction'] != null ? IconButton(
              onPressed: widgetsList.elementAt(index)['trailingAction'],
              icon: FaIcon(FontAwesomeIcons.chevronRight, size: 16.0,),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.grey.shade100
              ),
            ) : null,
          );
        },
      ),
    );
  }
}
