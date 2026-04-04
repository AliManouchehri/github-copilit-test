const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.post('/api/greet', (req, res) => {
  const name = req.body.name || 'World';
  res.json({ message: `Hello, ${name}!` });
});

app.listen(PORT, () => {
  console.log(`Node app running at http://localhost:${PORT}`);
});
