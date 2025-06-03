const express = require("express");
const mysql = require("mysql");
const app = express();
const port = process.env.PORT || 3000;

const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: "admin",
  password: "YourSecurePassword123",
  database: "test"
});

app.get("/", (req, res) => {
  db.query("SELECT NOW()", (err, result) => {
    if (err) res.send(err);
    else res.send(`Database time: ${result[0]['NOW()']}`);
  });
});

app.listen(port, () => {
  console.log(`Backend running on port ${port}`);
});
