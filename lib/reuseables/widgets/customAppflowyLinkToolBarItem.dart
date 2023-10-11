import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

final customLinkMobileToolbarItem = MobileToolbarItem.withMenu(
  itemIcon: const ImageIcon(
    AssetImage(
      "lib/resources/icons/link.png",
    ),
    size: 16,
  ),
  itemMenuBuilder: (editorState, selection, itemMenuService) {
    final String? linkText = editorState.getDeltaAttributeValueInSelection(
      AppFlowyRichTextKeys.href,
      selection,
    );

    return MobileLinkMenu(
      editorState: editorState,
      linkText: linkText,
      onSubmitted: (value) async {
        if (value.isNotEmpty) {
          await editorState.formatDelta(selection, {
            AppFlowyRichTextKeys.href: value,
          });
        }
        itemMenuService.closeItemMenu();
        editorState.service.keyboardService?.closeKeyboard();
      },
      onCancel: () => itemMenuService.closeItemMenu(),
    );
  },
);

class MobileLinkMenu extends StatefulWidget {
  const MobileLinkMenu({
    super.key,
    this.linkText,
    required this.editorState,
    required this.onSubmitted,
    required this.onCancel,
  });

  final String? linkText;
  final EditorState editorState;
  final void Function(String) onSubmitted;
  final void Function() onCancel;

  @override
  State<MobileLinkMenu> createState() => _MobileLinkMenuState();
}

class _MobileLinkMenuState extends State<MobileLinkMenu> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    widget.editorState.service.keyboardService?.disable();
    _textEditingController = TextEditingController(text: widget.linkText ?? '');
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    widget.editorState.service.keyboardService?.enable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = MobileToolbarStyle.of(context);
    const double spacing = 8;
    return SizedBox(
      height: style.toolbarHeight * 2 + spacing,
      child: Column(
        children: [
          TextField(
            autofocus: true,
            controller: _textEditingController,
            keyboardType: TextInputType.url,
            onSubmitted: widget.onSubmitted,
            cursorColor: style.foregroundColor,
            decoration: InputDecoration(
              hintText: 'URL',
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 8,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: style.itemOutlineColor,
                ),
                borderRadius: BorderRadius.circular(style.borderRadius),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: style.primaryColor,
                ),
                borderRadius: BorderRadius.circular(style.borderRadius),
              ),
              suffixIcon: IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                icon: const Icon(
                  Icons.clear_rounded,
                  size: 16,
                ),
                onPressed: _textEditingController.clear,
                splashRadius: 16,
              ),
            ),
          ),
          const SizedBox(height: spacing),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.onCancel.call();
                  },
                  style: ButtonStyle(
     
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(style.borderRadius),
                      ),
                    ),
                    
                  ),
                  child: Text(
                    AppFlowyEditorLocalizations.current.cancel,
                  ),
                ),
              ),
              SizedBox(width: style.buttonSpacing),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSubmitted.call(_textEditingController.text);
                    widget.editorState.service.keyboardService
                        ?.closeKeyboard();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      style.primaryColor,
                    ),
                    foregroundColor: MaterialStateProperty.all(
                      style.onPrimaryColor,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(style.borderRadius),
                      ),
                    ),
                  ),
                  child: Text(
                    AppFlowyEditorLocalizations.current.done,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
