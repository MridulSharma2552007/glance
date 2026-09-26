const { createClient } = require("@supabase/supabase-js");

const supabaseUrl = "https://fjlnagbwnwfzyiafwhzn.supabase.co";
const supabaseKey = "sb_publishable_j_MzGLtWTh124TAFLL7mIA_wB-0BxyR";

const supabase = createClient(supabaseUrl, supabaseKey);

module.exports = supabase;