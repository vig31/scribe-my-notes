// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../reuseables/widgets/customToolBarIconButton.dart';

class CreateAndEditScreenView extends StatefulWidget {
  const CreateAndEditScreenView({Key? key}) : super(key: key);

  @override
  State<CreateAndEditScreenView> createState() =>
      _CreateAndEditScreenViewState();
}

class _CreateAndEditScreenViewState extends State<CreateAndEditScreenView> {
  final QuillController _controller = QuillController(
    document: Document(),
    selection: TextSelection(baseOffset: 0, extentOffset: 0),
  );
  final FocusNode _node = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            iconSize: 18,
            onPressed: () {},
            icon: Icon(Icons.push_pin_outlined),
          ),
          IconButton(
            iconSize: 18,
            enableFeedback: true,
            onPressed: () {},
            tooltip: "Add remainder",
            icon: Icon(Icons.notifications_outlined),
          ),
          IconButton(
            iconSize: 18,
            onPressed: () {},
            icon: Icon(Icons.bookmark_outline),
          ),
          IconButton(
            iconSize: 18,
            onPressed: () {},
            icon: Icon(Icons.image_outlined),
          ),
          IconButton(
            iconSize: 18,
            onPressed: () {},
            icon: Icon(Icons.more_vert_outlined),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 350,
            child: QuillEditor(
              controller: _controller,
              focusNode: _node,
              scrollController: _scrollController,
              scrollable: true,
              padding: EdgeInsets.all(16),
              autoFocus: true,
              readOnly: false,
              expands: true,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BottomAppBar(
        child: Row(
          children: [
            ToggleStyleButton(
              attribute: Attribute.bold,
              icon: Icons.format_bold,
              controller: _controller,
              childBuilder: customChildBuilder,
            ),
          ],
        ),
      ),
    );
  }
}
