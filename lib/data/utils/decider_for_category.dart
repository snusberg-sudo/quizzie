import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class DeciderForCategory {
  final String category;

  DeciderForCategory({required this.category});

  final categoryMapper = {
    'プログラミング' : Symbols.code,
    '数学': Symbols.function_rounded,
    '科学' : Symbols.glyphs,
    '言語' : Symbols.experiment_sharp
  };

  IconData? get decideCategory {
    return categoryMapper[category];
  }
}