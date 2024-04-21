const {
  getFirestore,
  collection,
  query,
  where,
  doc,
  getDoc,
  getDocs,
  addDoc,
  setDoc,
  updateDoc,
  deleteDoc,
  serverTimestamp,
} = require("firebase/firestore");

const updTs = { updatedAt: serverTimestamp() };

const allowedToReadDoc = (path1, path2, path3, path4) => (allowed) => allowed
  ? path3
    ? expect(
      getDoc(doc(getFirestore(), path1, path2, path3, path4))
    ).resolves.toBeDefined()
    : expect(
      getDoc(doc(getFirestore(), path1, path2))
    ).resolves.toBeDefined()
  : path3
    ? expect(
      getDoc(doc(getFirestore(), path1, path2, path3, path4))
    ).rejects.toThrow()
    : expect(
      getDoc(doc(getFirestore(), path1, path2))
    ).rejects.toThrow();

const allowedToUpdateDoc = (path1, path2, path3, path4) => (allowed) => allowed
  ? path3
    ? expect(
      updateDoc(doc(getFirestore(), path1, path2, path3, path4), updTs)
    ).resolves.toBeUndefined()
    : expect(
      updateDoc(doc(getFirestore(), path1, path2), updTs)
    ).resolves.toBeUndefined()
  : path3
    ? expect(
      updateDoc(doc(getFirestore(), path1, path2, path3, path4), updTs)
    ).rejects.toThrow()
    : expect(
      updateDoc(doc(getFirestore(), path1, path2), updTs)
    ).rejects.toThrow();

const allowedToDeleteDoc = (path1, path2, path3, path4) => (allowed) => allowed
  ? path3
    ? expect(
      deleteDoc(doc(getFirestore(), path1, path2, path3, path4))
    ).resolves.toBeUndefined()
    : expect(
      deleteDoc(doc(getFirestore(), path1, path2))
    ).resolves.toBeUndefined()
  : path3
    ? expect(
      deleteDoc(doc(getFirestore(), path1, path2, path3, path4))
    ).rejects.toThrow()
    : expect(
      deleteDoc(doc(getFirestore(), path1, path2))
    ).rejects.toThrow();

const allowedToListDocs = (path1, path2, path3) => (allowed) => allowed
  ? path3
    ? expect(
      getDocs(collection(getFirestore(), path1, path2, path3))
    ).resolves.toBeDefined()
    : expect(
      getDocs(collection(getFirestore(), path1))
    ).resolves.toBeDefined()
  : path3
    ? expect(
      getDocs(collection(getFirestore(), path1, path2, path3))
    ).rejects.toThrow()
    : expect(
      getDocs(collection(getFirestore(), path1))
    ).rejects.toThrow();

const allowedToAddDoc = (path1, path2, path3, path4) => (allowed) => allowed
  ? path4
    ? expect(
      setDoc(doc(getFirestore(), path1, path2, path3, path4), updTs)
    ).resolves.toBeUndefined()
    : path3
      ? expect(
        addDoc(collection(getFirestore(), path1, path2, path3), updTs)
      ).resolves.toBeDefined()
      : path2
        ? expect(
          setDoc(doc(getFirestore(), path1, path2), updTs)
        ).resolves.toBeUndefined()
        : expect(
          addDoc(collection(getFirestore(), path1), updTs)
        ).resolves.toBeDefined()
  : path3
    ? expect(
      addDoc(collection(getFirestore(), path1, path2, path3), updTs)
    ).rejects.toThrow()
    : expect(
      addDoc(collection(getFirestore(), path1), updTs)
    ).rejects.toThrow();

module.exports = {
  allowedToReadDoc,
  allowedToUpdateDoc,
  allowedToDeleteDoc,
  allowedToListDocs,
  allowedToAddDoc,
};
