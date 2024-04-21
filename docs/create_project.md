# 参考: このプロジェクトの初期構築

<https://console.firebase.google.com/>

- Add project
    - Project name: kyubikohub
    - Configure Google Analytics
        - Create a new account: kyubikohub
        - Analytics location: Japan
- Projects: kyubikohub
    - Project Overview
        - Project settings
            - Default GCP resource location: asia-northeast2 (Osaka)
            - Environment Type: Production
            - </> ( Web )
                - App nickname: Kyubiko Hub
                - o Use npm -- Save code
                - Link to a Firebase Hosting site: kyubikohub
        - Usage and billing
            - Details & settings
                - Firebase billing plan: Blaze
    - Build
        - Authentication
            - Sign-in method
                - Email/Password: Enable
                    - Email link (passwordless sign-in): Enable
                - Google: Enable
                    - Public-facing name for project: Kyubiko Hub
                - Identity Platform: Upgrade to enable
            - Templates
                - Template language: Japanese
            - Settings
                - Blocking functions
                    - Upgrade to Firebase Auth with Identity Platform
                    - Enable Functions
        - Firestore database
            - Mode: Datastore
                - Actions: Delete
            - Create database
                - Native mode
                - Region: asia-northeast2 (Osaka)
                - Production rules
        - Storage
            - o Start in production mode

```bash
$ java --version
openjdk 21.0.2 2024-01-16

$ nvm --version
0.39.7

$ node --version
v18.19.1

$ fvm --version
3.1.3

$ fvm list
3.19.5 stable (global)

$ fvm flutter create -t app --platforms web kyubikohub
$ cd kyubikohub
$ fvm use 3.19.5

$ echo 18 > .nvmrc
$ npm init
$ npm i firebase-tools -D
$ npx firebase init

? Which Firebase features do you want to set up for this directory?
Firestore: Configure security rules and indexes files for Firestore,
Functions: Configure a Cloud Functions directory and its files,
Hosting: Configure files for Firebase Hosting and (optionally) set up GitHub Action deploys,
Hosting: Set up GitHub Action deploys,
Storage: Configure a security rules file for Cloud Storage,
Emulators: Set up local emulators for Firebase products
? Please select an option: Use an existing project
? Select a default Firebase project for this directory: kyubikohub (kyubikohub)
? What file should be used for Firestore Rules? firestore.rules
? What file should be used for Firestore indexes? firestore.indexes.json
? What language would you like to use to write Cloud Functions? Python
? Do you want to install dependencies now? Yes
? What do you want to use as your public directory? build/web
? Configure as a single-page app (rewrite all urls to /index.html)? No
? Set up automatic builds and deploys with GitHub? Yes
? For which GitHub repository would you like to set up a GitHub workflow?  MichinobuMaeda/kyubikohub
? Set up the workflow to run a build script before every deploy? No
? Set up automatic deployment to your site's live channel when a PR is merged? Yes
? What is the name of the GitHub branch associated with your site's live channel? main
i  Action required: Visit this URL to revoke authorization for the Firebase CLI GitHub OAuth App:
https://github.com/settings/connections/applications/89cf50f02ac6aaed3484
? What file should be used for Storage Rules? storage.rules
? Which Firebase emulators do you want to set up? Press Space to select emulators, then Enter to confirm your choices. Authentication Emulator, Functions Emulator, Firestore Emulator, Storage Emulator
? Which port do you want to use for the auth emulator? 9099
? Which port do you want to use for the functions emulator? 5001
? Which port do you want to use for the firestore emulator? 8080
? Which port do you want to use for the pubsub emulator? 8085
? Which port do you want to use for the storage emulator? 9199
? Would you like to enable the Emulator UI? Yes
? Which port do you want to use for the Emulator UI (leave empty to use any available port)? 4040
? Would you like to download the emulators now? Yes

$ rm build/web/*
```

Create icons by <https://realfavicongenerator.net>.

<https://www.google.com/recaptcha/admin/create>

- Register a new site
    - Label: kyubikohub.web.app
    - Domains: kyubikohub.web.app
    - Google Cloud Platform: kyubikohub

Set site key to `webRecaptchaSiteKey` in `lib/config.dart`.

<https://console.firebase.google.com/>

- Projects: kyubikohub
    - Build
        - App check
            - Apps
                - kyubikohub
                    - reCAPTCHA
                        - reCAPTCHA secret key: ********
        - Firestore database
            - add `service/deployment` with timestamp field `createdAt`

<https://github.com/MichinobuMaeda/curkyubikohubuviho/settings/secrets/actions>

Set secrets

- FIREBASE_API_KEY_KYUBIKOHUB
- FUNCTIONS_ENV_KYUBIKOHUB

<https://console.cloud.google.com/>

- Select a project: kyubikohub
    - IAM & Admin
        - github-action-**@kyubikohub.iam.gserviceaccount.com
            - Add
                - Cloud Functions Admin
                - Firebase Admin SDK Administrator Service Agent
                - Firebase Rules Admin
                - Service Account User
                - Storage Admin
