// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homePage.model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomePageModel on _HomePageModelBase, Store {
  late final _$isLoadingAtom =
      Atom(name: '_HomePageModelBase.isLoading', context: context);

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

  late final _$todaysRemainderAtom =
      Atom(name: '_HomePageModelBase.todaysRemainder', context: context);

  @override
  List<Note> get todaysRemainder {
    _$todaysRemainderAtom.reportRead();
    return super.todaysRemainder;
  }

  @override
  set todaysRemainder(List<Note> value) {
    _$todaysRemainderAtom.reportWrite(value, super.todaysRemainder, () {
      super.todaysRemainder = value;
    });
  }

  late final _$pinnedNotesAtom =
      Atom(name: '_HomePageModelBase.pinnedNotes', context: context);

  @override
  List<Note> get pinnedNotes {
    _$pinnedNotesAtom.reportRead();
    return super.pinnedNotes;
  }

  @override
  set pinnedNotes(List<Note> value) {
    _$pinnedNotesAtom.reportWrite(value, super.pinnedNotes, () {
      super.pinnedNotes = value;
    });
  }

  late final _$allNotesAtom =
      Atom(name: '_HomePageModelBase.allNotes', context: context);

  @override
  List<Note> get allNotes {
    _$allNotesAtom.reportRead();
    return super.allNotes;
  }

  @override
  set allNotes(List<Note> value) {
    _$allNotesAtom.reportWrite(value, super.allNotes, () {
      super.allNotes = value;
    });
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
todaysRemainder: ${todaysRemainder},
pinnedNotes: ${pinnedNotes},
allNotes: ${allNotes}
    ''';
  }
}
