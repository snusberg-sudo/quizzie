import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizSearchBar extends StatefulWidget {
  const QuizSearchBar({super.key});

  @override
  State<QuizSearchBar> createState() => _QuizSearchBarState();
}

class _QuizSearchBarState extends State<QuizSearchBar> {
  final SearchController _searchController = SearchController();
  final List<String> _suggestions = ['Apple', 'Banana', 'Cherry', 'Date'];
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      isFullScreen: true,
      searchController: _searchController,
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView();
          },
          onChanged: (value) {
            controller.openView();
          },
          leading: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 12.0, color: Colors.black87,),
          constraints: BoxConstraints(minHeight: 38.0),
          side: WidgetStatePropertyAll(BorderSide(color: Colors.black87, width: 1.25)),
          backgroundColor: WidgetStatePropertyAll(Colors.amberAccent.shade400),
          textStyle: WidgetStatePropertyAll(GoogleFonts.rubik(fontSize: 12.0)),
        );
      },
      suggestionsBuilder: (context, controller) {
        final query = controller.text.toLowerCase();
        return _suggestions
            .where((item) => item.toLowerCase().contains(query))
            .map((item) {
              return ListTile(title: Text(item));
            })
            .toList();
      },
    );
  }
}
