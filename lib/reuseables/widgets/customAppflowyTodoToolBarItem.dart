import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

final customTodoListMobileToolbarItem = MobileToolbarItem.action(
  itemIcon: const ImageIcon(
      AssetImage(
        "lib/resources/icons/checklist.png",
      ),
      size: 16,
    ),
  actionHandler: (editorState, selection) async {
    final node = editorState.getNodeAtPath(selection.start.path)!;
    final isTodoList = node.type == TodoListBlockKeys.type;

    editorState.formatNode(
      selection,
      (node) => node.copyWith(
        type: isTodoList ? ParagraphBlockKeys.type : TodoListBlockKeys.type,
        attributes: {
          TodoListBlockKeys.checked: false,
          ParagraphBlockKeys.delta: (node.delta ?? Delta()).toJson(),
        },
      ),
    );
  },
);
