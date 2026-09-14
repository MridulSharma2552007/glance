const express = require("express");
const crypto = require("crypto");
const router = express.Router();
const supabase = require("../db");

router.post("/signup", async (req, res) => {
    const { roll_no, email, faceVector } = req.body;

    if (!roll_no || !email || !faceVector) {
        return res.status(400).json({ error: "roll_no, email, and faceVector are required" });
    }

    try {
        const auth_token = crypto.randomBytes(32).toString("hex");

        const { data, error } = await supabase
            .from("student")
            .insert([{ roll_no, email, face_vector: faceVector, auth_token }])
            .select()
            .single();

        if (error) {
            if (error.code === "23505") {
                return res.status(409).json({ error: "Roll number or email already registered" });
            }
            console.error(error);
            return res.status(500).json({ error: "Server error" });
        }

        return res.status(201).json({
            message: "Signup successful",
            auth_token: data.auth_token,
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: "Server error" });
    }
});

module.exports = router;