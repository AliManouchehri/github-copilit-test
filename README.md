# github-copilit-test

This repo contains two sample basic web apps: one using **Flask** (Python) and one using **Node.js** (Express).

Both apps expose:
- `GET /` — serves an HTML page with a name input form
- `POST /api/greet` — accepts `{ "name": "..." }` JSON and returns `{ "message": "Hello, ...!" }`

---

## Flask App

**Requirements:** Python 3.8+

```bash
cd flask-app

# Create and activate a virtual environment (recommended)
python3 -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run
python app.py
```

Open http://localhost:5000 in your browser.

---

## Node.js App

**Requirements:** Node.js 18+

```bash
cd node-app

# Install dependencies
npm install

# Run
npm start

# Or run with auto-reload during development
npm run dev
```

Open http://localhost:3000 in your browser.
