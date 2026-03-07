import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

type RegisterPayload = {
  name?: string;
  email?: string;
  password?: string;
  referralCode?: string;
  kycId?: string;
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
  });
}

function isValidEmail(email: string) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function generateRefCode() {
  return "REF" + crypto.randomUUID().replace(/-/g, "").slice(0, 6).toUpperCase();
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !serviceRoleKey) {
      return json({ error: "Missing Supabase server configuration" }, 500);
    }

    const payload = (await req.json()) as RegisterPayload;
    const name = (payload.name || "").trim();
    const email = (payload.email || "").trim().toLowerCase();
    const password = payload.password || "";
    const referralCode = (payload.referralCode || "").trim();
    const kycId = (payload.kycId || "").trim();

    if (!name || !email || !password || !kycId) {
      return json({ error: "Missing required fields" }, 400);
    }
    if (!isValidEmail(email)) {
      return json({ error: "Invalid email address" }, 400);
    }
    if (password.length < 6) {
      return json({ error: "Password must be at least 6 characters" }, 400);
    }

    const admin = createClient(supabaseUrl, serviceRoleKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    });

    const existingUser = await admin
      .from("users")
      .select("id")
      .eq("email", email)
      .maybeSingle();
    if (existingUser.error) {
      return json({ error: existingUser.error.message }, 500);
    }
    if (existingUser.data) {
      return json({ error: "البريد مسجل مسبقاً" }, 409);
    }

    let refBy: string | null = null;
    if (referralCode) {
      const refLookup = await admin
        .from("users")
        .select("id")
        .eq("ref_code", referralCode)
        .maybeSingle();
      if (!refLookup.error && refLookup.data) {
        refBy = refLookup.data.id;
      }
    }

    const createdAuth = await admin.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: { name },
    });

    if (createdAuth.error || !createdAuth.data.user) {
      const message = createdAuth.error?.message || "Unable to create auth user";
      const status = message.toLowerCase().includes("already") ? 409 : 400;
      return json({ error: message }, status);
    }

    let refCode = generateRefCode();
    for (let i = 0; i < 5; i += 1) {
      const codeCheck = await admin
        .from("users")
        .select("id")
        .eq("ref_code", refCode)
        .maybeSingle();
      if (!codeCheck.data) break;
      refCode = generateRefCode();
    }

    const inserted = await admin
      .from("users")
      .insert([
        {
          auth_user_id: createdAuth.data.user.id,
          name,
          email,
          password: "",
          kyc_id: kycId,
          kyc_status: "approved",
          status: "pending",
          balance: 0,
          profit_bal: 0,
          pending_profit: 0,
          bonus: 0,
          ref_code: refCode,
          ref_by: refBy,
          refs_count: 0,
          join_date: new Date().toISOString(),
        },
      ])
      .select("*")
      .single();

    if (inserted.error || !inserted.data) {
      await admin.auth.admin.deleteUser(createdAuth.data.user.id);
      return json({ error: inserted.error?.message || "Unable to create user profile" }, 500);
    }

    if (refBy) {
      const refCounter = await admin
        .from("users")
        .select("refs_count")
        .eq("id", refBy)
        .maybeSingle();
      const currentRefs = refCounter.data?.refs_count || 0;
      await admin
        .from("users")
        .update({ refs_count: currentRefs + 1 })
        .eq("id", refBy);
    }

    return json({
      ok: true,
      user: inserted.data,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unexpected error";
    return json({ error: message }, 500);
  }
});

