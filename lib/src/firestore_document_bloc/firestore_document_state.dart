import 'package:equatable/equatable.dart';
import 'package:firestore_bloc/src/repositories/firestore_path.dart';

import '../firestore_document.dart';

abstract class FirestoreDocumentState<T extends FirestoreDocument>
    extends Equatable {
  /// nullable, this is an indicator whether or not we will be observing a
  /// document that already exists or not
  FirestoreDocumentPath get documentId => null;

  @override
  List<Object> get props => [];

  bool get isCreationState => false;
}

class FirestoreDocumentUninitializedState<T extends FirestoreDocument>
    extends FirestoreDocumentState<T> {
  @override
  final FirestoreDocumentPath documentId;

  FirestoreDocumentUninitializedState(this.documentId);

  @override
  bool get isCreationState => documentId == null;
}

class FirestoreDocumentCreationFailedState<T extends FirestoreDocument>
    extends FirestoreDocumentState<T> {
  final dynamic error;

  FirestoreDocumentCreationFailedState(this.error);

  @override
  List<Object> get props => super.props..add(error);
}

abstract class FirestoreDocumentBlocInitializedState<
    T extends FirestoreDocument> extends FirestoreDocumentState<T> {
  @override
  final FirestoreDocumentPath documentId;

  FirestoreDocumentBlocInitializedState(this.documentId);

  @override
  List<Object> get props => super.props..add(documentId);
}

class FirestoreDocumentLoadingState<T extends FirestoreDocument>
    extends FirestoreDocumentBlocInitializedState<T> {
  FirestoreDocumentLoadingState(FirestoreDocumentPath documentId) : super(documentId);
}

class FirestoreDocumentLoadFailedState<T extends FirestoreDocument>
    extends FirestoreDocumentBlocInitializedState<T> {
  final Object error;

  FirestoreDocumentLoadFailedState(this.error, FirestoreDocumentPath documentId)
      : super(documentId);

  @override
  List<Object> get props => super.props..addAll([error]);

  @override
  String toString() {
    return 'FirebaseDocumentStateLoadFailed {error: $error}';
  }
}

class FirestoreDocumentLoadedState<T extends FirestoreDocument>
    extends FirestoreDocumentBlocInitializedState<T> {
  final T document;

  FirestoreDocumentLoadedState(this.document)
      : assert(document != null),
        super(document.path);

  @override
  List<Object> get props => super.props..addAll([document]);
}

class FirestoreDocumentUpdatingState<T extends FirestoreDocument>
    extends FirestoreDocumentLoadedState<T> {
  FirestoreDocumentUpdatingState(T document) : super(document);
}

class FirestoreDocumentDeletedState<T extends FirestoreDocument>
    extends FirestoreDocumentState<T> {}
