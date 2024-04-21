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
  await signInWithEmailAndPassword(getAuth(), "primary@example.com", "password");
  uid = getAuth().currentUser.uid;
  account = await getDoc(doc(getFirestore(), "orgs", "admins", "accounts", uid));
  me = account.get("user");
  // account = await getDoc(doc(getFirestore(), "orgs", "admins", "accounts", "primary_id"));
  // primary = account.get("user");
  // account = await getDoc(doc(getFirestore(), "orgs", "test", "accounts", "manager_id"));
  // manager = account.get("user");
});

afterAll(async () => {
  await deleteApp(app);
});

describe('After Sing-in as Primary User', () => {
  it('0000', () => allowedToReadDoc("service", "conf")(true));
  it('0001', () => allowedToUpdateDoc("service", "conf")(true));
  it('0002', () => allowedToDeleteDoc("service", "conf")(false));
  it('0003', () => allowedToAddDoc("service")(false));

  it('0010', () => allowedToReadDoc("orgs", "admins")(true));
  it('0011', () => allowedToReadDoc("orgs", "test")(true));
  it('0012', () => allowedToUpdateDoc("orgs", "admins")(true));
  it('0013', () => allowedToUpdateDoc("orgs", "test")(true));
  it('0014', () => allowedToDeleteDoc("orgs", "admins")(false));
  it('0015', () => allowedToDeleteDoc("orgs", "to_delete")(true));
  it('0016', () => allowedToAddDoc("orgs")(true));
  it('0017', () => allowedToListDocs("orgs")(true));

  it('0020', () => allowedToAddDoc("orgs", "admins", "accounts", "test00")(true));
  it('0021', () => allowedToDeleteDoc("orgs", "admins", "accounts", "test00")(true));
  it('0022', () => allowedToListDocs("orgs", "admins", "accounts")(true));
  it('0023', () => allowedToReadDoc("orgs", "admins", "accounts", uid)(true));
  it('0024', () => allowedToUpdateDoc("orgs", "admins", "accounts", uid)(false));
  it('0025', () => allowedToDeleteDoc("orgs", "admins", "accounts", uid)(false));

  it('0030', () => allowedToAddDoc("orgs", "test", "accounts")(false));
  it('0031', () => allowedToDeleteDoc("orgs", "test", "accounts", "to_delete")(false));
  it('0032', () => allowedToListDocs("orgs", "test", "accounts")(false));
  it('0033', () => allowedToReadDoc("orgs", "test", "accounts", "manager_id")(false));
  it('0034', () => allowedToUpdateDoc("orgs", "test", "accounts", "manager_id")(false));
  it('0035', () => allowedToDeleteDoc("orgs", "test", "accounts", "manager_id")(false));

  it('0040', () => allowedToAddDoc("orgs", "admins", "users", "test00")(true));
  it('0041', () => allowedToDeleteDoc("orgs", "admins", "users", "test00")(true));
  it('0042', () => allowedToListDocs("orgs", "admins", "users")(true));
  it('0043', () => allowedToUpdateDoc("orgs", "admins", "users", me)(true));
  it('0044', () => allowedToDeleteDoc("orgs", "admins", "users", me)(false));

  it('0050', () => allowedToAddDoc("orgs", "test", "users")(false));
  it('0051', () => allowedToDeleteDoc("orgs", "test", "users", "to_delete")(false));
  it('0052', () => allowedToListDocs("orgs", "test", "users")(false));
  // it('0053', () => allowedToUpdateDoc("orgs", "test", "users", me)(false));
  // it('0054', () => allowedToDeleteDoc("orgs", "test", "users", me)(false));
  // it('0055', () => allowedToUpdateDoc("orgs", "test", "users", manager)(false));
  // it('0056', () => allowedToDeleteDoc("orgs", "test", "users", manager)(false));

  it('0060', () => allowedToAddDoc("orgs", "admins", "groups", "test00")(true));
  it('0061', () => allowedToUpdateDoc("orgs", "admins", "groups", "to_delete")(true));
  it('0062', () => allowedToDeleteDoc("orgs", "admins", "groups", "to_delete")(true));
  it('0063', () => allowedToListDocs("orgs", "admins", "groups")(true));
  it('0064', () => allowedToUpdateDoc("orgs", "admins", "groups", "managers")(true));
  it('0065', () => allowedToDeleteDoc("orgs", "admins", "groups", "managers")(false));

  it('0070', () => allowedToAddDoc("orgs", "test", "groups", "test00")(false));
  it('0071', () => allowedToUpdateDoc("orgs", "test", "groups", "to_delete")(false));
  it('0072', () => allowedToDeleteDoc("orgs", "test", "groups", "to_delete")(false));
  it('0073', () => allowedToListDocs("orgs", "test", "groups")(false));
  it('0074', () => allowedToUpdateDoc("orgs", "test", "groups", "managers")(false));
  it('0075', () => allowedToUpdateDoc("orgs", "test", "groups", "group01")(false));
});
