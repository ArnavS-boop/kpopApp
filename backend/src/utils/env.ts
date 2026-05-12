export const checkEnv = () => {
  const required = ["DATABASE_URL", "JWT_SECRET"];
  const missing = required.filter((key) => !process.env[key]);

  if (missing.length > 0) {
    throw new Error(`Missing required environment variables: ${missing.join(", ")}`);
  }
};
