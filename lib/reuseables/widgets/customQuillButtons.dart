// import 'package:flutter/material.dart';
// import 'package:flutter_quill/extensions.dart';
// import 'package:flutter_quill/flutter_quill.dart'
//     show
//         kDefaultIconSize,
//         QuillController,
//         QuillIconTheme,
//         QuillDialogTheme,
//         LinkDialogAction,
//         Node,
//         Attribute,
//         LinkAttribute;

// class CustomToolIconButton extends StatelessWidget {
//   const CustomToolIconButton({
//     required this.onPressed,
//     this.afterPressed,
//     this.icon,
//     this.size = 40,
//     this.fillColor,
//     this.hoverElevation = 1,
//     this.highlightElevation = 1,
//     this.borderRadius = 2,
//     this.tooltip,
//     Key? key,
//   }) : super(key: key);

//   final VoidCallback? onPressed;
//   final VoidCallback? afterPressed;
//   final Widget? icon;
//   final double size;
//   final Color? fillColor;
//   final double hoverElevation;
//   final double highlightElevation;
//   final double borderRadius;
//   final String? tooltip;

//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: BoxConstraints.tightFor(width: size, height: size),
//       child: UtilityWidgets.maybeTooltip(
//         message: tooltip,
//         child: RawMaterialButton(
//           visualDensity: VisualDensity.compact,
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(borderRadius)),
//           fillColor: fillColor,
//           elevation: 0,
//           hoverElevation: hoverElevation,
//           highlightElevation: hoverElevation,
//           onPressed: () {
//             onPressed?.call();
//             afterPressed?.call();
//           },
//           child: icon,
//         ),
//       ),
//     );
//   }
// }

// Widget customChildBuilder(
//   BuildContext context,
//   Attribute attribute,
//   IconData icon,
//   Color? fillColor,
//   bool? isToggled,
//   VoidCallback? onPressed,
//   VoidCallback? afterPressed, [
//   double iconSize = kDefaultIconSize,
//   QuillIconTheme? iconTheme,
// ]) {
//   final theme = Theme.of(context);
//   final isEnabled = onPressed != null;
//   final iconColor = isEnabled
//       ? isToggled == true
//           ? (iconTheme?.iconSelectedColor ??
//               theme.colorScheme
//                   .onPrimaryContainer) //You can specify your own icon color
//           : (iconTheme?.iconUnselectedColor ?? theme.iconTheme.color)
//       : (iconTheme?.disabledIconColor ?? theme.disabledColor);
//   final fill = isEnabled
//       ? isToggled == true
//           ? (iconTheme?.iconSelectedFillColor ??
//               theme.colorScheme.primaryContainer) //Selected icon fill color
//           : Colors.transparent //Unselected icon fill color :
//       : Colors.transparent; //Disabled icon fill color
//   return CustomToolIconButton(
//     highlightElevation: 0,
//     hoverElevation: 0,
//     size: iconSize * 1.6,
//     icon: ImageIcon(
//       AssetImage(
//         "lib/resources/icons/${icon.fontFamily?.toLowerCase()}.png",
//       ),
//       color: iconColor,
//       size: iconSize,
//     ),
//     fillColor: fill,
//     onPressed: onPressed,
//     afterPressed: afterPressed,
//     borderRadius: 4,
//   );
// }

// class CustomHistoryButton extends StatefulWidget {
//   const CustomHistoryButton({
//     required this.icon,
//     required this.controller,
//     required this.undo,
//     this.iconSize = kDefaultIconSize,
//     this.iconTheme,
//     this.afterButtonPressed,
//     this.tooltip,
//     Key? key,
//   }) : super(key: key);

//   final IconData icon;
//   final double iconSize;
//   final bool undo;
//   final QuillController controller;
//   final QuillIconTheme? iconTheme;
//   final VoidCallback? afterButtonPressed;
//   final String? tooltip;

//   @override
//   _CustomHistoryButtonState createState() => _CustomHistoryButtonState();
// }

// class _CustomHistoryButtonState extends State<CustomHistoryButton> {
//   Color? _iconColor;
//   late ThemeData theme;

//   @override
//   Widget build(BuildContext context) {
//     theme = Theme.of(context);
//     _setIconColor();

//     final fillColor =
//         widget.iconTheme?.iconUnselectedFillColor ?? theme.canvasColor;
//     widget.controller.changes.listen((event) async {
//       _setIconColor();
//     });
//     return CustomToolIconButton(
//       tooltip: widget.tooltip,
//       highlightElevation: 0,
//       hoverElevation: 0,
//       size: widget.iconSize * 1.6,
//       icon: ImageIcon(
//         AssetImage(
//           "lib/resources/icons/${widget.icon.fontFamily?.toLowerCase()}.png",
//         ),
//         color: _iconColor,
//         size: widget.iconSize,
//       ),
//       fillColor: fillColor,
//       borderRadius: widget.iconTheme?.borderRadius ?? 2,
//       onPressed: _changeHistory,
//       afterPressed: widget.afterButtonPressed,
//     );
//   }

//   void _setIconColor() {
//     if (!mounted) return;

//     if (widget.undo) {
//       setState(() {
//         _iconColor = widget.controller.hasUndo
//             ? widget.iconTheme?.iconUnselectedColor ?? theme.iconTheme.color
//             : widget.iconTheme?.disabledIconColor ?? theme.disabledColor;
//       });
//     } else {
//       setState(() {
//         _iconColor = widget.controller.hasRedo
//             ? widget.iconTheme?.iconUnselectedColor ?? theme.iconTheme.color
//             : widget.iconTheme?.disabledIconColor ?? theme.disabledColor;
//       });
//     }
//   }

//   void _changeHistory() {
//     if (widget.undo) {
//       if (widget.controller.hasUndo) {
//         widget.controller.undo();
//       }
//     } else {
//       if (widget.controller.hasRedo) {
//         widget.controller.redo();
//       }
//     }

//     _setIconColor();
//   }
// }

// class CustomLinkStyleButton extends StatefulWidget {
//   const CustomLinkStyleButton({
//     required this.controller,
//     this.iconSize = kDefaultIconSize,
//     this.icon,
//     this.iconTheme,
//     this.dialogTheme,
//     this.afterButtonPressed,
//     this.tooltip,
//     this.linkRegExp,
//     this.linkDialogAction,
//     Key? key,
//   }) : super(key: key);

//   final QuillController controller;
//   final IconData? icon;
//   final double iconSize;
//   final QuillIconTheme? iconTheme;
//   final QuillDialogTheme? dialogTheme;
//   final VoidCallback? afterButtonPressed;
//   final String? tooltip;
//   final RegExp? linkRegExp;
//   final LinkDialogAction? linkDialogAction;

//   @override
//   _CustomLinkStyleButtonState createState() => _CustomLinkStyleButtonState();
// }

// class _CustomLinkStyleButtonState extends State<CustomLinkStyleButton> {
//   void _didChangeSelection() {
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addListener(_didChangeSelection);
//   }

//   @override
//   void didUpdateWidget(covariant CustomLinkStyleButton oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.controller != widget.controller) {
//       oldWidget.controller.removeListener(_didChangeSelection);
//       widget.controller.addListener(_didChangeSelection);
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     widget.controller.removeListener(_didChangeSelection);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isToggled = _getLinkAttributeValue() != null;
//     final pressedHandler = () => _openLinkDialog(context);
//     return CustomToolIconButton(
//       tooltip: widget.tooltip,
//       highlightElevation: 0,
//       hoverElevation: 0,
//       size: widget.iconSize * 1.6,
//       icon: ImageIcon(
//         AssetImage(
//           "lib/resources/icons/${widget.icon?.fontFamily?.toLowerCase()}.png",
//         ),
//         color: isToggled
//             ? (widget.iconTheme?.iconSelectedColor ??
//                 theme.colorScheme
//                     .onPrimaryContainer) //You can specify your own icon color
//             : (widget.iconTheme?.iconUnselectedColor ?? theme.iconTheme.color),
//         size: widget.iconSize,
//       ),
//       fillColor: isToggled
//           ? (widget.iconTheme?.iconSelectedFillColor ??
//               Theme.of(context)
//                   .colorScheme
//                   .primaryContainer) //Selected icon fill color
//           : Colors.transparent, //Unselected icon fill color
//       borderRadius: 4,
//       onPressed: pressedHandler,
//       afterPressed: widget.afterButtonPressed,
//     );
//   }

//   void _openLinkDialog(BuildContext context) {
//     showDialog<_TextLink>(
//       context: context,
//       builder: (ctx) {
//         final link = _getLinkAttributeValue();
//         final index = widget.controller.selection.start;

//         var text;
//         if (link != null) {
//           // text should be the link's corresponding text, not selection
//           final leaf =
//               widget.controller.document.querySegmentLeafNode(index).leaf;
//           if (leaf != null) {
//             text = leaf.toPlainText();
//           }
//         }

//         final len = widget.controller.selection.end - index;
//         text ??=
//             len == 0 ? '' : widget.controller.document.getPlainText(index, len);
//         return _LinkDialog(
//           dialogTheme: widget.dialogTheme,
//           link: link,
//           text: text,
//           linkRegExp: widget.linkRegExp,
//           action: widget.linkDialogAction,
//         );
//       },
//     ).then(
//       (value) {
//         if (value != null) _linkSubmitted(value);
//       },
//     );
//   }

//   String? _getLinkAttributeValue() {
//     return widget.controller
//         .getSelectionStyle()
//         .attributes[Attribute.link.key]
//         ?.value;
//   }

//   void _linkSubmitted(_TextLink value) {
//     var index = widget.controller.selection.start;
//     var length = widget.controller.selection.end - index;
//     if (_getLinkAttributeValue() != null) {
//       // text should be the link's corresponding text, not selection
//       final leaf = widget.controller.document.querySegmentLeafNode(index).leaf;
//       if (leaf != null) {
//         final range = _getLinkRange(leaf);
//         index = range.start;
//         length = range.end - range.start;
//       }
//     }
//     widget.controller.replaceText(index, length, value.text, null);
//     widget.controller
//         .formatText(index, value.text.length, LinkAttribute(value.link));
//   }
// }

// class _LinkDialog extends StatefulWidget {
//   const _LinkDialog({
//     this.dialogTheme,
//     this.link,
//     this.text,
//     this.linkRegExp,
//     this.action,
//     Key? key,
//   }) : super(key: key);

//   final QuillDialogTheme? dialogTheme;
//   final String? link;
//   final String? text;
//   final RegExp? linkRegExp;
//   final LinkDialogAction? action;

//   @override
//   _LinkDialogState createState() => _LinkDialogState();
// }

// class _LinkDialogState extends State<_LinkDialog> {
//   late String _link;
//   late String _text;
//   late RegExp linkRegExp;
//   late TextEditingController _linkController;
//   late TextEditingController _textController;

//   @override
//   void initState() {
//     super.initState();
//     _link = widget.link ?? '';
//     _text = widget.text ?? '';
//     linkRegExp = widget.linkRegExp ?? AutoFormatMultipleLinksRule.linkRegExp;
//     _linkController = TextEditingController(text: _link);
//     _textController = TextEditingController(text: _text);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: widget.dialogTheme?.dialogBackgroundColor,
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(height: 8),
//           TextField(
//             keyboardType: TextInputType.multiline,
//             style: widget.dialogTheme?.inputTextStyle,
//             decoration: InputDecoration(
//               labelText: 'Text',
//               labelStyle: widget.dialogTheme?.labelTextStyle,
//               floatingLabelStyle: widget.dialogTheme?.labelTextStyle,

//             ),
//             autofocus: true,
//             onChanged: _textChanged,
//             controller: _textController,
//           ),
//           const SizedBox(height: 16),
//           TextField(
//             keyboardType: TextInputType.multiline,
//             style: widget.dialogTheme?.inputTextStyle,
//             decoration: InputDecoration(
//                 labelText: 'Link',
//                 labelStyle: widget.dialogTheme?.labelTextStyle,
//                 floatingLabelStyle: widget.dialogTheme?.labelTextStyle),
//             autofocus: true,
//             onChanged: _linkChanged,
//             controller: _linkController,
//           ),
//         ],
//       ),
//       actions: [_okButton()],
//     );
//   }

//   Widget _okButton() {
//     if (widget.action != null) {
//       return widget.action!.builder(_canPress(), _applyLink);
//     }

//     return TextButton(
//       onPressed: _canPress() ? _applyLink : null,
//       child: Text(
//         'Ok',
//         style: widget.dialogTheme?.buttonTextStyle,
//       ),
//     );
//   }

//   bool _canPress() {
//      if (_text.isEmpty || _link.isEmpty || _text.trim().isEmpty || _link.trim().isEmpty) {
//       return false;
//     }
//     return true;
//   }

//   void _linkChanged(String value) {
//     setState(() {
//       _link = value;
//     });
//   }

//   void _textChanged(String value) {
//     setState(() {
//       _text = value;
//     });
//   }

//   void _applyLink() {
//     Navigator.pop(context, _TextLink(_text.trim(), _link.trim()));
//   }
// }

// class _TextLink {
//   _TextLink(
//     this.text,
//     this.link,
//   );

//   final String text;
//   final String link;
// }

// TextRange _getLinkRange(Node node) {
//   var start = node.documentOffset;
//   var length = node.length;
//   var prev = node.previous;
//   final linkAttr = node.style.attributes[Attribute.link.key]!;
//   while (prev != null) {
//     if (prev.style.attributes[Attribute.link.key] == linkAttr) {
//       start = prev.documentOffset;
//       length += prev.length;
//       prev = prev.previous;
//     } else {
//       break;
//     }
//   }

//   var next = node.next;
//   while (next != null) {
//     if (next.style.attributes[Attribute.link.key] == linkAttr) {
//       length += next.length;
//       next = next.next;
//     } else {
//       break;
//     }
//   }
//   return TextRange(start: start, end: start + length);
// }
