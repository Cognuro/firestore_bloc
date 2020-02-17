import 'dart:async';

import 'package:firestore_doc/firestore_doc.dart';

import '../../firestore_bloc.dart';

typedef CustomStreamLoader<T extends FirestoreDocument> = Stream<List<T>>
    Function();

abstract class FirestoreCollectionBloc<T extends FirestoreDocument,
    R extends FirestoreRepository<T>> extends FirestoreQueryBloc<T, R> {
  final R collectionRepo;
  final FirestoreCollectionPath collectionPath;

  FirestoreCollectionBloc(this.collectionRepo, this.collectionPath)
      : super(collectionRepo);

  Future<T> addDocument(T document) async {
    try {
      T addedDocument =
          await collectionRepo.addDocument(collectionPath, document);
      return addedDocument;
    } catch (e) {
      print('error adding document: $e');
      rethrow;
    }
  }

  Future<void> deleteDocument(String documentId) async {
    try {
      await collectionRepo.deleteDocument(collectionPath.document(documentId));
    } catch (e) {
      print('error deleting document: $e');
      rethrow;
    }
  }

  void loadAll() {
    super.load(() => collectionRepo.queryAll(collectionPath));
  }
}
