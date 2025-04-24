// const apiConfig = {
//     endpoint: 'http://backend:8000/api'

// }

// let response =  fetch('http://backend:8000/api/task');
// console.log(response);
// const express = require('express');
// const app = express();

// app.get('/', async (req, res) => {
//     try {
//         // Appelle la route correcte du backend
//         const response = await fetch('http://backend:8000/api/task');
//         if (!response.ok) {
//             throw new Error(`Erreur HTTP ${response.status}`);
//         }
//         const data = await response.json();
//         res.json(data); // Renvoie les données au client
//     } catch (error) {
//         console.error('Erreur lors de la récupération des tâches:', error);
//         res.status(500).json({ error: 'Erreur serveur' });
//     }
// });

// app.listen(5173, () => {
//     console.log('Frontend démarré sur le port 5173');
// });
/* const express = require('express');
const path = require('path');
const app = express();

// Servir les fichiers statiques (dist/ pour bundle.js)
app.use(express.static(path.join(__dirname, 'dist')));

// Servir index.html par défaut
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(8080, () => {
  console.log('Frontend démarré sur le port 8080');
}); */
const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

// Serve static files from multiple directories
app.use(express.static(path.join(__dirname, 'dist')));
app.use(express.static(path.join(__dirname, 'css')));
app.use(express.static(path.join(__dirname, 'js')));
app.use(express.static(path.join(__dirname)));

// Serve index.html for all routes
app.get('*', (req, res) => {
  console.log(`Serving ${req.url}`);
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(port, () => {
  console.log(`Server running on port http://localhost:${port}`);
});