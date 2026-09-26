const supabase = require("../db");

async function getSubjects(req, res) {
    try {
        const { data, error } = await supabase
            .from("subject")
            .select("*");

        if (error) {
            console.error(error);
            return res.status(500).json({ error: "Server error" });
        }

        return res.status(200).json(data);
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: "Server error" });
    }
}

module.exports = { getSubjects };