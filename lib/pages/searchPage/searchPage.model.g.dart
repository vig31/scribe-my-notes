// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searchPage.model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SearchPageModel on _SearchPageModelBase, Store {
  late final _$quiredNotesAtom =
      Atom(name: '_SearchPageModelBase.quiredNotes', context: context);

  @override
  List<Note> get quiredNotes {
    _$quiredNotesAtom.reportRead();
    return super.quiredNotes;
  }

  @override
  set quiredNotes(List<Note> value) {
    _$quiredNotesAtom.reportWrite(value, super.quiredNotes, () {
      super.quiredNotes = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_SearchPageModelBase.isLoading', context: context);

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

  @override
  String toString() {
    return '''
quiredNotes: ${quiredNotes},
isLoading: ${isLoading}
    ''';
  }
}
