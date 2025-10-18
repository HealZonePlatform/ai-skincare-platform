import { NextResponse } from "next/server";
import { analyzeSkin } from "@/services/gemini";

export const runtime = "nodejs"; // hoặc 'edge' nếu SDK hỗ trợ

export async function POST(req: Request) {
  try {
    const { imageBase64, mimeType } = await req.json();
    if (!imageBase64 || !mimeType) {
      return NextResponse.json(
        { error: "Thiếu imageBase64 hoặc mimeType" },
        { status: 400 }
      );
    }
    const result = await analyzeSkin(imageBase64, mimeType);
    return NextResponse.json(result);
  } catch (e: any) {
    return NextResponse.json(
      { error: e?.message ?? "Lỗi không xác định" },
      { status: 500 }
    );
  }
}