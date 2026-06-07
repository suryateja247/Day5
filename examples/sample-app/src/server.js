const express = require('express');

const app = express();
const port = process.env.PORT || 8080;

app.get('/health', (_req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.get('/', (_req, res) => {
  res.send('Sample app delivered by Jenkins, Docker, Artifactory/Nexus, and Kubernetes.');
});

app.listen(port, () => {
  console.log(`sample-app listening on ${port}`);
});
