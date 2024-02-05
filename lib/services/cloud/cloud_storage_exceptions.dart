class CloudStorageExcption implements Exception {
  const CloudStorageExcption();
}

// C in CRUD
class CouldNotCreatenNoteException extends CloudStorageExcption {}

// R in CRUD
class CouldNotGetAllNotesException extends CloudStorageExcption {}

// U in CRUD
class CouldNotUpdateNoteException extends CloudStorageExcption {}

// D in CRUD
class CouldNotDeleteNoteException extends CloudStorageExcption {}
