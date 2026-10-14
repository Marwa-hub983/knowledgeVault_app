# Vault: Personal Knowledge Vault

A cross-platform mobile app (iOS and Android) where you upload your documents and ask questions about them in chat. Answers come **only from your own files**, and every answer shows its source.

> Status: in development (v1 in progress)

---

## Overview

Vault is a personal search engine and assistant for your documents. Instead of opening many PDFs to find one answer, you ask a question in plain language. The app finds the relevant passages in your files, answers from them, and cites the document and page. If the answer is not in your documents, it says so instead of guessing.

This is built with **RAG** (Retrieval-Augmented Generation).

## Features (v1)

- Email and password authentication (Firebase Auth)
- Upload PDF and TXT documents
- Processing status per document: Uploaded, Processing, Ready, Failed
- Ask questions with streamed answers and source citations
- Source viewer showing the exact passage behind each answer
- Folders to organize documents
- AI data consent screen before first use
- Delete account (removes documents and vectors from the server)
- Local storage with SQLite for documents, chunks and chat history

### Planned (v1.1 and later)

- Dedicated Search screen (keyword and semantic)
- Chat History screen
- Folders & Tags management screen
- Google and Apple sign-in
- DOCX support
- iOS CI/CD
- Biometric lock, scan and OCR, flashcards, offline sync, export

## How it works

**Adding a document**

1. The app uploads the file to the Node server.
2. The server extracts the text, page by page.
3. The text is split into chunks of about 500 tokens with a small overlap. Each chunk keeps its document and page number.
4. Each chunk is converted into an embedding (a vector of numbers that captures its meaning).
5. Chunk text and embeddings are stored. The document status becomes **Ready**.

**Asking a question**

1. The question is converted into an embedding.
2. The server retrieves the top-k most similar chunks.
3. A prompt is built from those chunks and the question, with the instruction to answer only from the context and to say "Not found in your documents" otherwise.
4. The LLM generates the answer, streamed to the app over SSE.
5. The app shows the answer with citation chips. Tapping a chip opens the source passage.

```
Upload -> Extract text -> Chunk -> Embed -> Store          (once per document)
Question -> Embed -> Find similar chunks -> LLM answer -> Answer + sources
```

## Tech stack

| Layer | Technology |
|---|---|
| Mobile app | Flutter, flutter_bloc (BLoC/Cubit), GoRouter, Dio |
| Local database | SQLite via drift (FTS5 for keyword search) |
| Auth | Firebase Auth (token verified on the server) |
| Backend | Node.js (Express or Fastify), multer, pdf-parse, zod |
| Vector store | Postgres with pgvector (or sqlite-vec) |
| AI | LLM API for answers, embeddings provider for vectors (keys stay on the server) |
| CI/CD | GitHub Actions |

## Architecture

```
Flutter app
  UI (BLoC) -> Repository (abstract) -> Local (drift/SQLite)
                                     -> Remote (Dio -> Node API)

Node API
  Auth middleware -> Upload -> Extract -> Chunk -> Embed -> Vector DB
                  -> /ask: embed question -> retrieve -> LLM -> SSE stream
```

The UI only talks to repository interfaces, so mock, local and remote data sources can be swapped without changing screens.

## Project structure

```
lib/
  core/
    theme/
    router/
    constants/
    utils/
    widgets/            # shared: status_chip, file_icon, empty_state
  data/
    models/
    repositories/
    local/              # drift database
    remote/             # Dio, API client
  features/
    auth/
      splash/
      onboarding/
      login/
      register/
    home/
    library/
    document/
      add_document/
      document_detail/
    consent/
    chat/
      chat/
      source_viewer/
    settings/
  main.dart
```

Each feature folder contains:

```
bloc/
view/
widgets/
```

## Screens (v1)

| # | Screen | Purpose |
|---|---|---|
| 1 | Splash | Logo, token and onboarding check |
| 2 | Onboarding | 4 slides explaining the concept |
| 3 | Login / Register | Email and password |
| 4 | Home | Recent documents, quick Ask bar, processing banner |
| 5 | Library | Document list, filters, status chips |
| 6 | Add Document | Pick a file, set title and folder |
| 7 | Document Detail | Metadata, extracted text, chunks, actions |
| 8 | Chat (Ask Vault) | Questions, streamed answers, citations |
| 9 | Source Viewer | Exact passage behind a citation |
| 10 | Settings | Profile, appearance, AI options, delete account |
| 11 | AI Data Consent | Disclosure and permission before first use |

## Local database schema (drift)

```
documents(id, title, type, file_path, folder_id, status, created_at, updated_at, remote_id)
folders(id, name, parent_id)
tags(id, name)
document_tags(document_id, tag_id)
chunks(id, document_id, chunk_index, text, page, token_count)
chunks_fts                      -- FTS5 virtual table on chunks.text
conversations(id, title, scope_type, scope_id, created_at)
messages(id, conversation_id, role, content, citations_json, created_at)
```

Store `file_path` **relative** to the app documents directory. iOS can change the absolute app path between updates.

## API endpoints

```
POST   /auth/verify              Verify Firebase token, create user
GET    /documents                List documents (paginated)
POST   /documents                Upload file (multipart)
GET    /documents/:id
DELETE /documents/:id
POST   /documents/:id/reindex
GET    /documents/:id/status     Poll processing status
POST   /search                   { query, mode: keyword|semantic, topK }
POST   /ask                      { question, scope, conversationId } -> SSE stream
GET    /conversations
GET    /conversations/:id
DELETE /account                  Delete user, documents and vectors
```

## Getting started

### Prerequisites

- Flutter SDK (stable)
- Node.js (LTS) and npm
- Postgres with the pgvector extension (or sqlite-vec)
- A Firebase project (Auth enabled)
- API keys for the LLM and embeddings provider
- Xcode and a Mac for iOS builds

### Mobile app

```bash
cd app
flutter pub get
flutter run
```

Add your Firebase config files:

- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

Set the API base URL in `lib/core/constants/` (see Networking notes below).

### Backend

```bash
cd server
npm install
cp .env.example .env     # then fill in the values
npm run dev
```

Example `.env`:

```
PORT=3000
DATABASE_URL=postgres://user:password@localhost:5432/vault
FIREBASE_PROJECT_ID=your-project-id
LLM_API_KEY=your-llm-key
EMBEDDINGS_API_KEY=your-embeddings-key
DAILY_QUESTION_LIMIT=50
```

Never commit `.env` or API keys. The mobile app must never contain AI provider keys.

## Platform notes

**iOS**

- Set the minimum iOS version in the `Podfile`.
- Add `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` to `Info.plist` if scan or image picking is added.
- iOS requires HTTPS for deployed backends (App Transport Security).
- Push notifications need an APNs key uploaded to Firebase and the Push Notifications capability in Xcode.
- Apple requires in-app account deletion, and disclosure and permission before personal data is sent to a third-party AI. Both are included in v1.
- If Google sign-in is added later, add Sign in with Apple too.

**Android**

- Standard Gradle build. `google-services.json` required.

**Networking in development**

| Target | Base URL |
|---|---|
| iOS simulator | `http://localhost:3000` |
| Android emulator | `http://10.0.2.2:3000` |
| Real device | `http://<your-computer-LAN-IP>:3000` |

**Background behavior**

iOS suspends apps shortly after they go to the background. Processing runs on the server, so it continues either way. Keep the app open during large uploads or use a background transfer package.

## CI/CD

GitHub Actions workflows:

**Flutter (on pull request and push)**

1. Checkout
2. Set up Flutter with caching
3. `flutter pub get`
4. `flutter analyze`
5. `flutter test`
6. On `main`: `flutter build apk --release`, upload the APK as an artifact

**Node (on pull request and push)**

1. Checkout
2. Set up Node with caching
3. `npm ci`
4. `npm run lint`
5. `npm test`
6. On `main`: build the Docker image and deploy (secrets in GitHub Secrets)

iOS builds need a macOS runner and code signing (for example fastlane `match`) with TestFlight upload through an App Store Connect API key. This is planned after the Android pipeline.

## Roadmap

| Phase | Weeks | Goal |
|---|---|---|
| UI with mock data | 1-3 | All 11 screens running on a mock repository |
| SQLite + repository | 3-5 | drift database behind the repository interface |
| Node API + auth + upload | 5-8 | Documents sync to the server |
| RAG pipeline + chat streaming | 8-11 | `/ask` returns streamed answers with citations |
| CI/CD (Android) + deploy | 11-12 | Push to `main` builds the APK and deploys the API |
| Polish + iOS testing | 13 | Error states, README, demo, real iPhone test |

## Known limitations (v1)

- Scanned PDFs without a text layer show a "No readable text found" failed state. OCR is planned.
- PDF and TXT only. DOCX is planned.
- A daily question limit applies per user to control API costs.

## Privacy

Document text is sent to an AI provider to answer questions. It is not used for advertising. Users can delete their account and all data from Settings. Add your privacy policy URL here before release.

## License

Add your license here (for example MIT).
