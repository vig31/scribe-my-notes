import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

final customHeadingMobileToolbarItem = MobileToolbarItem.withMenu(
  itemIcon: const Icon(
    Icons.h_mobiledata_rounded,
    size: 21,
  ),
  itemMenuBuilder: (editorState, selection, _) {
    return _HeadingMenu(
      selection,
      editorState,
    );
  },
);

class _HeadingMenu extends StatefulWidget {
  const _HeadingMenu(
    this.selection,
    this.editorState, {
    Key? key,
  }) : super(key: key);

  final Selection selection;
  final EditorState editorState;

  @override
  State<_HeadingMenu> createState() => _HeadingMenuState();
}

class _HeadingMenuState extends State<_HeadingMenu> {
  final headings = [
    CustomHeadingUnit(
      label: AppFlowyEditorLocalizations.current.mobileHeading1,
      level: 1,
    ),
    CustomHeadingUnit(
      label: AppFlowyEditorLocalizations.current.mobileHeading2,
      level: 2,
    ),
    CustomHeadingUnit(
      label: AppFlowyEditorLocalizations.current.mobileHeading3,
      level: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final style = MobileToolbarStyle.of(context);
    final size = MediaQuery.sizeOf(context);
    final btnList = headings.map((currentHeading) {
      // Check if current node is heading and its level
      final node =
          widget.editorState.getNodeAtPath(widget.selection.start.path)!;
      final isSelected = node.type == HeadingBlockKeys.type &&
          node.attributes[HeadingBlockKeys.level] == currentHeading.level;

      return ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          // 3 buttons in a row
          width: (size.width - 4 * style.buttonSpacing) / 3,
        ),
        child: MobileToolbarItemMenuBtn(
          icon: _getHeadingIcons(currentHeading.level),
          label: Text(
            currentHeading.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
             fontSize: 12,
            ),
          ),
          isSelected: isSelected,
          onPressed: () {
            setState(() {
              widget.editorState.formatNode(
                widget.selection,
                (node) => node.copyWith(
                  type: isSelected
                      ? ParagraphBlockKeys.type
                      : HeadingBlockKeys.type,
                  attributes: {
                    HeadingBlockKeys.level: currentHeading.level,
                    HeadingBlockKeys.backgroundColor:
                        node.attributes[blockComponentBackgroundColor],
                    ParagraphBlockKeys.delta: (node.delta ?? Delta()).toJson(),
                  },
                ),
              );
            });
          },
        ),
      );
    }).toList();

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: size.width),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: btnList,
      ),
    );
  }
}

class CustomHeadingUnit {
  final String label;
  final int level;

  CustomHeadingUnit({
    required this.label,
    required this.level,
  });
}

Widget _getHeadingIcons(int level) {
  if (level == 2) {
    return const ImageIcon(
      AssetImage(
        "lib/resources/icons/h2.png",
      ),
      size: 16,
    );
  } else if (level == 3) {
    return const ImageIcon(
      AssetImage(
        "lib/resources/icons/h3.png",
      ),
      size: 16,
    );
  }
  return const ImageIcon(
    AssetImage(
      "lib/resources/icons/h1.png",
    ),
    size: 16,
  );
}
