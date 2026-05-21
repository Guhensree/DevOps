const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

app.post('/audit', (req, res) => {
  const event = req.body;
  console.log('Received audit event:', event);
  // Here you would typically store the event in a database
  res.status(202).json({ message: 'Audit event accepted' });
});

app.listen(port, () => {
  console.log(`Audit Event API listening on port ${port}`);
});
