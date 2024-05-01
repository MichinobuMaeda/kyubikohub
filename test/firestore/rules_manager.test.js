const { initializeApp, deleteApp } = require("firebase/app");
const {
  getAuth,
  connectAuthEmulator,
  signInWithEmailAndPassword,
} = require("firebase/auth");
const {
  getFirestore,
  connectFirestoreEmulator,
  getDoc,
  doc,
} = require("firebase/firestore");
const conf = require("./config");
const {
  allowedToReadDoc,
  allowedToUpdateDoc,
  allowedToDeleteDoc,
  allowedToListDocs,
  allowedToAddDoc,
} = require("./utils");

var app = initializeApp(conf.firebase_options);
connectAuthEmulator(getAuth(), `http://${conf.auth_host}:${conf.auth_port}`);
connectFirestoreEmulator(getFirestore(), conf.firestore_host, conf.firestore_port);
var uid;
var me;
// var primary;
// var manager;

beforeAll(async () => {
  await signInWithEmailAndPassword(getAuth(), "manager@example.com", "password");
  uid = getAuth().currentUser.uid;
  account = await getDoc(doc(getFirestore(), "sites", "test", "accounts", uid));
  me = account.get("user");
  // account = await getDoc(doc(getFirestore(), "sites", "admins", "accounts", "primary_id"));
  // primary = account.get("user");
  account = await getDoc(doc(getFirestore(), "sites", "test", "accounts", "manager_id"));
  manager = account.get("user");
});

afterAll(async () => {
  await deleteApp(app);
});

describe('After Sing-in as Manager', () => {
  it('0000', () => allowedToReadDoc("service", "conf")(true));
  it('0001', () => allowedToUpdateDoc("service", "conf")(false));
  it('0002', () => allowedToDeleteDoc("service", "conf")(false));
  it('0003', () => allowedToAddDoc("service")(false));

  it('0010', () => allowedToReadDoc("sites", "admins")(true));
  it('0011', () => allowedToReadDoc("sites", "test")(true));
  it('0012', () => allowedToUpdateDoc("sites", "admins")(false));
  it('0013', () => allowedToUpdateDoc("sites", "test")(true));
  it('0014', () => allowedToDeleteDoc("sites", "admins")(false));
  it('0015', () => allowedToDeleteDoc("sites", "to_delete")(false));
  it('0016', () => allowedToAddDoc("sites")(false));
  it('0017', () => allowedToListDocs("sites")(true));

  it('0020', () => allowedToAddDoc("sites", "admins", "accounts", "test00")(false));
  // it('0021', () => allowedToDeleteDoc("sites", "admins", "accounts", "test00")(false));
  it('0022', () => allowedToListDocs("sites", "admins", "accounts")(false));
  it('0023', () => allowedToReadDoc("sites", "admins", "accounts", "primary_id")(false));
  it('0024', () => allowedToUpdateDoc("sites", "admins", "accounts", "primary_id")(false));
  it('0025', () => allowedToDeleteDoc("sites", "admins", "accounts", "primary_id")(false));

  it('0030', () => allowedToAddDoc("sites", "test", "accounts")(true));
  it('0031', () => allowedToDeleteDoc("sites", "test", "accounts", "to_delete")(true));
  it('0032', () => allowedToListDocs("sites", "test", "accounts")(true));
  it('0033', () => allowedToReadDoc("sites", "test", "accounts", uid)(true));
  it('0034', () => allowedToUpdateDoc("sites", "test", "accounts", uid)(false));
  it('0035', () => allowedToDeleteDoc("sites", "test", "accounts", uid)(false));

  it('0040', () => allowedToAddDoc("sites", "admins", "users", "test00")(false));
  it('0041', () => allowedToDeleteDoc("sites", "admins", "users", "test00")(false));
  it('0042', () => allowedToListDocs("sites", "admins", "users")(false));
  // it('0043', () => allowedToUpdateDoc("sites", "admins", "users", primary)(false));
  // it('0044', () => allowedToDeleteDoc("sites", "admins", "users", primary)(false));

  it('0050', () => allowedToAddDoc("sites", "test", "users")(true));
  it('0051', () => allowedToDeleteDoc("sites", "test", "users", "to_delete")(true));
  it('0052', () => allowedToListDocs("sites", "test", "users")(true));
  it('0053', () => allowedToUpdateDoc("sites", "test", "users", me)(true));
  it('0054', () => allowedToDeleteDoc("sites", "test", "users", me)(false));
  // it('0055', () => allowedToUpdateDoc("sites", "test", "users", manager)(false));
  // it('0056', () => allowedToDeleteDoc("sites", "test", "users", manager)(false));

  it('0060', () => allowedToAddDoc("sites", "admins", "groups", "test00")(false));
  it('0061', () => allowedToUpdateDoc("sites", "admins", "groups", "test00")(false));
  it('0062', () => allowedToDeleteDoc("sites", "admins", "groups", "test00")(false));
  it('0063', () => allowedToListDocs("sites", "admins", "groups")(false));
  it('0064', () => allowedToUpdateDoc("sites", "admins", "groups", "managers")(false));
  it('0065', () => allowedToDeleteDoc("sites", "admins", "groups", "managers")(false));

  it('0070', () => allowedToAddDoc("sites", "test", "groups", "test00")(true));
  it('0071', () => allowedToUpdateDoc("sites", "test", "groups", "to_delete")(true));
  it('0072', () => allowedToDeleteDoc("sites", "test", "groups", "to_delete")(true));
  it('0073', () => allowedToListDocs("sites", "test", "groups")(true));
  it('0074', () => allowedToUpdateDoc("sites", "test", "groups", "managers")(true));
  it('0075', () => allowedToUpdateDoc("sites", "test", "groups", "group01")(true));
});
