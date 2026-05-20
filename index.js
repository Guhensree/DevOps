const express = require('express');
const app = express();
const port = 3000;

// Middleware to parse JSON bodies
app.use(express.json());

// Single POST endpoint for ingesting audit events
app.post('/audit', (req, res) => {
  const auditEvent = req.body;
  
  // Basic validation or processing could go here
  if (!auditEvent) {
    return res.status(400).json({ error: 'Audit event payload is missing' });
  }

  console.log('Ingested audit event:', auditEvent);
  
  // Respond with a success message
  res.status(202).json({ 
    message: 'Audit event received successfully',
    timestamp: new Date().toISOString()
  });
});

app.listen(port, () => {
  console.log(`Audit event API is running and listening on port ${port}`);
});
