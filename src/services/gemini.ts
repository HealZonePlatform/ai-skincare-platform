// src/services/gemini.ts
import { GoogleGenerativeAI, SchemaType, type Schema } from "@google/generative-ai";
import type { SkincareRoutine } from "@/types";

// ✅ THÊM PHẦN NÀY - Lazy initialization pattern
let genAI: GoogleGenerativeAI | null = null;
let model: any = null;

function getModel() {
  if (!model) {
    const API_KEY = process.env.API_KEY;
    if (!API_KEY) {
      throw new Error("API_KEY environment variable is not set");
    }
    genAI = new GoogleGenerativeAI(API_KEY);
    model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });
  }
  return model;
}


// 👇 Quan trọng: dùng kiểu Schema, KHÔNG 'as const'
const responseSchema: Schema = {
  type: SchemaType.OBJECT,
  properties: {
    skinType: { type: SchemaType.STRING },
    concerns: { type: SchemaType.ARRAY, items: { type: SchemaType.STRING } },
    amRoutine: {
      type: SchemaType.ARRAY,
      items: {
        type: SchemaType.OBJECT,
        properties: {
          step: { type: SchemaType.STRING },
          productType: { type: SchemaType.STRING },
          reason: { type: SchemaType.STRING }
        },
        // KHÔNG readonly
        required: ["step", "productType", "reason"]
      }
    },
    pmRoutine: {
      type: SchemaType.ARRAY,
      items: {
        type: SchemaType.OBJECT,
        properties: {
          step: { type: SchemaType.STRING },
          productType: { type: SchemaType.STRING },
          reason: { type: SchemaType.STRING }
        },
        required: ["step", "productType", "reason"]
      }
    },
    disclaimer: { type: SchemaType.STRING },
    imageUrl: { type: SchemaType.STRING } // Thêm trường imageUrl vào schema
  },
  required: ["skinType", "concerns", "amRoutine", "pmRoutine", "disclaimer"]
};


export async function analyzeSkin(imageBase64: string, mimeType: string): Promise<SkincareRoutine> {
  // ✅ Lấy model qua lazy initialization - chỉ chạy lúc runtime
  const modelInstance = getModel();
  
  const imagePart = { inlineData: { data: imageBase64, mimeType } };
  const textPart = {
    text: `Với vai trò là một chuyên gia da liễu AI, hãy phân tích hình ảnh khuôn mặt này.
Xác định loại da & vấn đề chính. Tạo quy trình AM/PM (step, productType, reason).
Kết thúc bằng disclaimer. Trả lời tiếng Việt. Chỉ xuất JSON theo schema.`
  };


  const resp = await modelInstance.generateContent({
    contents: [{ role: "user", parts: [imagePart, textPart] }],
    generationConfig: {
      responseMimeType: "application/json",
      responseSchema,          // <-- đúng kiểu Schema
      temperature: 0.5
    }
  });


  const text = resp.response.text();
  try {
    return JSON.parse(text) as SkincareRoutine;
  } catch {
    console.error("JSON from model:", text);
    throw new Error("Phản hồi từ AI không đúng định dạng JSON.");
  }
}
