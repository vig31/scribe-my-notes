// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'createAndEditPage.model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreateAndEditPageModel on _CreateAndEditPageModelBase, Store {
  late final _$tagsAtom =
      Atom(name: '_CreateAndEditPageModelBase.tags', context: context);

  @override
  List<Tag> get tags {
    _$tagsAtom.reportRead();
    return super.tags;
  }

  @override
  set tags(List<Tag> value) {
    _$tagsAtom.reportWrite(value, super.tags, () {
      super.tags = value;
    });
  }

  late final _$selectedTagAtom =
      Atom(name: '_CreateAndEditPageModelBase.selectedTag', context: context);

  @override
  Tag? get selectedTag {
    _$selectedTagAtom.reportRead();
    return super.selectedTag;
  }

  @override
  set selectedTag(Tag? value) {
    _$selectedTagAtom.reportWrite(value, super.selectedTag, () {
      super.selectedTag = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_CreateAndEditPageModelBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isPinnedAtom =
      Atom(name: '_CreateAndEditPageModelBase.isPinned', context: context);

  @override
  bool get isPinned {
    _$isPinnedAtom.reportRead();
    return super.isPinned;
  }

  @override
  set isPinned(bool value) {
    _$isPinnedAtom.reportWrite(value, super.isPinned, () {
      super.isPinned = value;
    });
  }

  late final _$selectedImagePathAtom = Atom(
      name: '_CreateAndEditPageModelBase.selectedImagePath', context: context);

  @override
  String get selectedImagePath {
    _$selectedImagePathAtom.reportRead();
    return super.selectedImagePath;
  }

  @override
  set selectedImagePath(String value) {
    _$selectedImagePathAtom.reportWrite(value, super.selectedImagePath, () {
      super.selectedImagePath = value;
    });
  }

  late final _$isAssestImageAtom =
      Atom(name: '_CreateAndEditPageModelBase.isAssestImage', context: context);

  @override
  bool get isAssestImage {
    _$isAssestImageAtom.reportRead();
    return super.isAssestImage;
  }

  @override
  set isAssestImage(bool value) {
    _$isAssestImageAtom.reportWrite(value, super.isAssestImage, () {
      super.isAssestImage = value;
    });
  }

  @override
  String toString() {
    return '''
tags: ${tags},
selectedTag: ${selectedTag},
isLoading: ${isLoading},
isPinned: ${isPinned},
selectedImagePath: ${selectedImagePath},
isAssestImage: ${isAssestImage}
    ''';
  }
}
