import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/data/python_cheatsheet_data.dart';

class CheatsheetScreen extends StatelessWidget {
  final String? chapterId;

  const CheatsheetScreen({super.key, this.chapterId});

  List<Map<String, String>> _getGlobalSection(String title) {
    final all = {
      'Variables & Data Types': [
        {'name': 'int', 'syntax': 'x = 10', 'desc': 'Integer number'},
        {'name': 'float', 'syntax': 'y = 3.14', 'desc': 'Decimal number'},
        {'name': 'str', 'syntax': 'name = "Harry"', 'desc': 'Text string'},
        {'name': 'bool', 'syntax': 'flag = True', 'desc': 'True/False'},
        {'name': 'list', 'syntax': 'nums = [1, 2, 3]', 'desc': 'Mutable ordered collection'},
        {'name': 'tuple', 'syntax': 't = (1, 2, 3)', 'desc': 'Immutable ordered collection'},
        {'name': 'dict', 'syntax': 'd = {"a": 1}', 'desc': 'Key-value pairs'},
        {'name': 'set', 'syntax': 's = {1, 2, 3}', 'desc': 'Unique unordered elements'},
      ],
      'Strings': [
        {'name': 'Concatenate', 'syntax': '"Hello" + " World"', 'desc': 'Join strings'},
        {'name': 'Multiply', 'syntax': '"Hi" * 3', 'desc': 'Repeat string'},
        {'name': 'Slice', 'syntax': 's[1:4]', 'desc': 'Extract substring'},
        {'name': 'Length', 'syntax': 'len(s)', 'desc': 'String length'},
        {'name': 'Upper', 'syntax': 's.upper()', 'desc': 'Uppercase'},
        {'name': 'Lower', 'syntax': 's.lower()', 'desc': 'Lowercase'},
        {'name': 'Strip', 'syntax': 's.strip()', 'desc': 'Remove whitespace'},
        {'name': 'Split', 'syntax': 's.split(",")', 'desc': 'Split into list'},
        {'name': 'Replace', 'syntax': 's.replace("a","b")', 'desc': 'Replace substring'},
        {'name': 'f-string', 'syntax': 'f"Hello {name}"', 'desc': 'Formatted string'},
      ],
      'Lists': [
        {'name': 'Append', 'syntax': 'list.append(x)', 'desc': 'Add to end'},
        {'name': 'Insert', 'syntax': 'list.insert(i, x)', 'desc': 'Insert at index'},
        {'name': 'Pop', 'syntax': 'list.pop()', 'desc': 'Remove last item'},
        {'name': 'Remove', 'syntax': 'list.remove(x)', 'desc': 'Remove first match'},
        {'name': 'Sort', 'syntax': 'list.sort()', 'desc': 'Sort ascending'},
        {'name': 'Reverse', 'syntax': 'list.reverse()', 'desc': 'Reverse order'},
        {'name': 'Comprehension', 'syntax': '[x*2 for x in list]', 'desc': 'Create new list'},
      ],
      'Dictionaries': [
        {'name': 'Get', 'syntax': 'd.get(key)', 'desc': 'Safe access'},
        {'name': 'Keys', 'syntax': 'd.keys()', 'desc': 'All keys'},
        {'name': 'Values', 'syntax': 'd.values()', 'desc': 'All values'},
        {'name': 'Items', 'syntax': 'd.items()', 'desc': 'Key-value pairs'},
        {'name': 'Update', 'syntax': 'd.update({k:v})', 'desc': 'Merge dicts'},
      ],
      'Control Flow': [
        {'name': 'if-elif-else', 'syntax': 'if x > 0:\\n  print("positive")', 'desc': 'Conditional'},
        {'name': 'for loop', 'syntax': 'for i in range(5):', 'desc': 'Loop over range'},
        {'name': 'while loop', 'syntax': 'while x < 10:', 'desc': 'Loop while true'},
        {'name': 'break', 'syntax': 'break', 'desc': 'Exit loop'},
        {'name': 'continue', 'syntax': 'continue', 'desc': 'Skip iteration'},
        {'name': 'match-case', 'syntax': 'match x:\\n  case 1:', 'desc': 'Pattern matching (3.10+)'},
      ],
      'Functions': [
        {'name': 'Define', 'syntax': 'def func():', 'desc': 'Define function'},
        {'name': 'Lambda', 'syntax': 'lambda x: x*2', 'desc': 'Anonymous function'},
        {'name': 'Args', 'syntax': 'def f(*args):', 'desc': 'Variable args'},
        {'name': 'kwargs', 'syntax': 'def f(**kwargs):', 'desc': 'Keyword args'},
        {'name': 'Return', 'syntax': 'return value', 'desc': 'Return value'},
      ],
      'File I/O': [
        {'name': 'Open', 'syntax': 'open("f.txt", "r")', 'desc': 'Open file'},
        {'name': 'Read', 'syntax': 'f.read()', 'desc': 'Read all'},
        {'name': 'Readline', 'syntax': 'f.readline()', 'desc': 'Read one line'},
        {'name': 'Write', 'syntax': 'f.write("text")', 'desc': 'Write text'},
        {'name': 'With', 'syntax': 'with open() as f:', 'desc': 'Auto-close'},
      ],
      'OOP': [
        {'name': 'Class', 'syntax': 'class MyClass:', 'desc': 'Define class'},
        {'name': 'Init', 'syntax': '__init__(self):', 'desc': 'Constructor'},
        {'name': 'Self', 'syntax': 'self.attr', 'desc': 'Instance attribute'},
        {'name': 'Inherit', 'syntax': 'class B(A):', 'desc': 'Inheritance'},
        {'name': 'Super', 'syntax': 'super().__init__()', 'desc': 'Parent constructor'},
      ],
      'Useful Built-ins': [
        {'name': 'print', 'syntax': 'print(x)', 'desc': 'Output'},
        {'name': 'input', 'syntax': 'input("> ")', 'desc': 'User input'},
        {'name': 'type', 'syntax': 'type(x)', 'desc': 'Get type'},
        {'name': 'len', 'syntax': 'len(x)', 'desc': 'Get length'},
        {'name': 'range', 'syntax': 'range(5)', 'desc': 'Generate numbers'},
        {'name': 'map', 'syntax': 'map(fn, list)', 'desc': 'Apply function'},
        {'name': 'filter', 'syntax': 'filter(fn, list)', 'desc': 'Filter items'},
        {'name': 'zip', 'syntax': 'zip(a, b)', 'desc': 'Combine lists'},
        {'name': 'enumerate', 'syntax': 'enumerate(list)', 'desc': 'Index + value'},
      ],
    };
    return all[title] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(chapterId != null && PythonCheatsheetData.chapterNames.containsKey(chapterId)
            ? '${PythonCheatsheetData.chapterNames[chapterId]} Cheatsheet'
            : 'Python Cheatsheet'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (chapterId != null && PythonCheatsheetData.chapterSections.containsKey(chapterId)) ...[
            _section(
              '${PythonCheatsheetData.chapterNames[chapterId]} — Quick Syntax',
              PythonCheatsheetData.chapterSections[chapterId]!,
              isDark,
            ),
            const SizedBox(height: 16),
          ],
          _section('Variables & Data Types', _getGlobalSection('Variables & Data Types'), isDark),
          _section('Strings', _getGlobalSection('Strings'), isDark),
          _section('Lists', _getGlobalSection('Lists'), isDark),
          _section('Dictionaries', _getGlobalSection('Dictionaries'), isDark),
          _section('Control Flow', _getGlobalSection('Control Flow'), isDark),
          _section('Functions', _getGlobalSection('Functions'), isDark),
          _section('File I/O', _getGlobalSection('File I/O'), isDark),
          _section('OOP', _getGlobalSection('OOP'), isDark),
          _section('Useful Built-ins', _getGlobalSection('Useful Built-ins'), isDark),
        ],
      ),
    );
  }

  Widget _section(String title, List<Map<String, String>> items, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code_rounded, size: 18, color: AppColors.tech),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: Text(item['name'] ?? '', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.tech, fontFamily: 'monospace')),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['syntax'] ?? '', style: TextStyle(fontSize: 12, color: const Color(0xFFE879F9), fontFamily: 'monospace', height: 1.4)),
                      Text(item['desc'] ?? '', style: TextStyle(fontSize: 11, color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight)),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
