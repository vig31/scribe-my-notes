import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

final customListMobileToolbarItem = MobileToolbarItem.withMenu(
  itemIcon: const Icon(
    Icons.menu_rounded,
    size: 16,
  ),
  itemMenuBuilder: (editorState, selection, _) {
    return _ListMenu(editorState, selection);
  },
);

class _ListMenu extends StatefulWidget {
  const _ListMenu(
    this.editorState,
    this.selection, {
    Key? key,
  }) : super(key: key);

  final Selection selection;
  final EditorState editorState;

  @override
  State<_ListMenu> createState() => _ListMenuState();
}

class _ListMenuState extends State<_ListMenu> {
  final lists = [
    CustomListUnit(
      iconName: "unordered_list",
      label: AppFlowyEditorLocalizations.current.bulletedList,
      name: 'bulleted_list',
    ),
    CustomListUnit(
      iconName: "ordered_list",
      label: AppFlowyEditorLocalizations.current.numberedList,
      name: 'numbered_list',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final btnList = lists.map((currentList) {
      // Check if current node is list and its type
      final node =
          widget.editorState.getNodeAtPath(widget.selection.start.path)!;
      final isSelected = node.type == currentList.name;

      return MobileToolbarItemMenuBtn(
        icon: ImageIcon(
          AssetImage(
            "lib/resources/icons/${currentList.iconName}.png",
          ),
          size: 16,
        ),
        label: Text(
          currentList.label,
          style: const TextStyle(fontSize: 12),
        ),
        isSelected: isSelected,
        onPressed: () {
          setState(() {
            widget.editorState.formatNode(
              widget.selection,
              (node) => node.copyWith(
                type: isSelected ? ParagraphBlockKeys.type : currentList.name,
                attributes: {
                  ParagraphBlockKeys.delta: (node.delta ?? Delta()).toJson(),
                },
              ),
            );
          });
        },
      );
    }).toList();

    return GridView(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 5,
      ),
      children: btnList,
    );
  }
}

class CustomListUnit {
  final String iconName;
  final String label;
  final String name;

  CustomListUnit({
    required this.iconName,
    required this.label,
    required this.name,
  });
}
