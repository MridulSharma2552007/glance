const express = require("express");
const cors = require("cors");
const { signup } = require("./routes/auth");
const { getSubjects } = require("./routes/subject");
const { getSemesters } = require("./routes/semester");

const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
    res.json({
        message: "Glance API is running..."
    });
});

app.post("/api/signup", signup);
app.get("/api/subjects", getSubjects);
app.get("/api/sem", getSemesters);

module.exports = app;