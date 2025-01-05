import * as bcrypt from "bcryptjs";

const SALT = 10;
export async function encodePassword(password: string) {
  const hash = await bcrypt.hash(password, SALT);

  return hash;
}
export async function comparePassword(password: string, hash: string) {
  return await bcrypt.compare(password, hash);
}
