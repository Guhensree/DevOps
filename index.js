const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware to parse JSON bodies
app.use(express.json());

// Single POST endpoint for ingesting audit events
app.post('/audit', (req, res) => {
  const event = req.body;
  
  if (!event || Object.keys(event).length === 0) {
    return res.status(400).json({ error: 'Event payload is required' });
  }

  // Log the event (in a real app, this might be saved to a database)
  console.log('[Audit Event]', JSON.stringify(event));

  res.status(201).json({ message: 'Audit event ingested successfully' });
});

app.listen(PORT, () => {
  console.log(`Audit Event API listening on port ${PORT}`);
});
