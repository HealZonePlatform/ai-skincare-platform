export type RoutineStep = {
  step: string;
  productType: string;
  reason: string;
};

export type SkincareRoutine = {
  skinType: string;
  concerns: string[];
  amRoutine: RoutineStep[];
  pmRoutine: RoutineStep[];
  disclaimer: string;
  imageUrl?: string; // Thêm trường imageUrl để hiển thị ảnh trong kết quả phân tích
};