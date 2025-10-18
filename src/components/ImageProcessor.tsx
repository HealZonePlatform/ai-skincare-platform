'use client'

import { useState, useCallback } from 'react';

interface ProcessedImage {
  base64: string;
  mimeType: string;
  fileSize: number;
}

export const useImageProcessor = () => {
  const [isProcessing, setIsProcessing] = useState(false);
  const [progress, setProgress] = useState(0);

  const processImage = useCallback((file: File): Promise<ProcessedImage> => {
    return new Promise((resolve, reject) => {
      if (!file.type.match('image.*')) {
        reject(new Error('File không phải là hình ảnh'));
        return;
      }

      const canvas = document.createElement('canvas');
      const ctx = canvas.getContext('2d');
      const img = new Image();

      img.onload = () => {
        try {
          // Tính toán kích thước mới để resize ảnh
          const maxWidth = 1024;
          const maxHeight = 1024;
          let { width, height } = img;

          if (width > height) {
            if (width > maxWidth) {
              height = (height * maxWidth) / width;
              width = maxWidth;
            }
          } else {
            if (height > maxHeight) {
              width = (width * maxHeight) / height;
              height = maxHeight;
            }
          }

          canvas.width = width;
          canvas.height = height;

          // Vẽ ảnh đã resize lên canvas
          ctx?.drawImage(img, 0, 0, width, height);

          // Chuyển đổi sang WebP nếu trình duyệt hỗ trợ, nếu không thì dùng JPEG
          const mimeType = canvas.toDataURL().startsWith('data:image/webp') ? 'image/webp' : 'image/jpeg';
          const quality = 0.8; // Chất lượng ảnh nén

          // Cập nhật tiến trình
          setProgress(50);

          // Chuyển đổi canvas sang base64
          const base64 = canvas.toDataURL(mimeType, quality);
          const base64Data = base64.split(',')[1] || '';

          // Tính toán kích thước file sau khi nén (ước lượng)
          const fileSize = Math.round((base64Data.length * 3) / 4);

          setProgress(100);
          resolve({
            base64: base64Data,
            mimeType,
            fileSize
          });
        } catch (error) {
          reject(error);
        }
      };

      img.onerror = () => {
        reject(new Error('Không thể tải ảnh'));
      };

      // Bắt đầu tải ảnh
      img.src = URL.createObjectURL(file);
    });
  }, []);

  const compressImage = useCallback((file: File): Promise<ProcessedImage> => {
    return new Promise((resolve, reject) => {
      setIsProcessing(true);
      setProgress(0);

      // Giả lập quá trình xử lý với tiến trình
      const interval = setInterval(() => {
        setProgress(prev => {
          if (prev >= 90) {
            clearInterval(interval);
            return prev;
          }
          return prev + 10;
        });
      }, 100);

      processImage(file)
        .then(result => {
          clearInterval(interval);
          setProgress(100);
          setIsProcessing(false);
          resolve(result);
        })
        .catch(error => {
          clearInterval(interval);
          setIsProcessing(false);
          reject(error);
        });
    });
  }, [processImage]);

  return {
    compressImage,
    isProcessing,
    progress
  };
};