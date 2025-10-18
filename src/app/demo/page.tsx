"use client";
import React, { useState, useEffect, useCallback } from "react";
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import type { SkincareRoutine } from "@/types";
import { AnalysisResult } from "@/components/AnalysisResult";



// Function to compress and process image
const processImageForUpload = (file: File): Promise<{ base64: string; mimeType: string; fileSize: number }> => {
  return new Promise((resolve, reject) => {
    if (!file.type || !file.type.match('image.*')) {
      reject(new Error('File không phải là hình ảnh'));
      return;
    }



    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');
    if (!ctx) {
      reject(new Error('Không thể tạo canvas context'));
      return;
    }



    const img = new Image();
    img.onload = () => {
      try {
        // Calculate new dimensions to resize image
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



        // Use high quality image smoothing for better visual results
        ctx.imageSmoothingEnabled = true;
        ctx.imageSmoothingQuality = 'high';



        // Draw resized image on canvas with high quality scaling
        ctx.drawImage(img, 0, 0, width, height);



        // Determine the best format based on original file type
        const isJPEG = file.type === 'image/jpeg' || file.type === 'image/jpg';
        const mimeType = isJPEG ? 'image/jpeg' : 'image/webp';



        // Compression quality - higher for JPEG to preserve quality, lower for WebP to reduce size
        const quality = isJPEG ? 0.8 : 0.7;



        // Convert canvas to base64 with optimized compression
        const base64 = canvas.toDataURL(mimeType, quality);
        if (!base64.includes(',')) {
          reject(new Error('Không thể chuyển đổi ảnh sang định dạng base64'));
          return;
        }
        const base64Data = base64.split(',')[1] || '';



        // Calculate compressed file size (approximation)
        const fileSize = Math.round((base64Data.length * 3) / 4);



        resolve({
          base64: base64Data,
          mimeType,
          fileSize
        });
      } catch (error) {
        reject(error);
      } finally {
        // Clean up the object URL after processing
        URL.revokeObjectURL(img.src);
      }
    };



    img.onerror = () => {
      URL.revokeObjectURL(img.src);
      reject(new Error('Không thể tải ảnh'));
    };



    // Start loading image
    img.src = URL.createObjectURL(file);
  });
};



export default function DemoPage() {
  const router = useRouter();
  const [file, setFile] = useState<File | null>(null);
  const [previewUrl, setPreviewUrl] = useState<string | null>(null); // Add state for preview URL
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<SkincareRoutine | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [uploadProgress, setUploadProgress] = useState(0);
  const [analysisProgress, setAnalysisProgress] = useState(0);
  const [isDragActive, setIsDragActive] = useState(false);



  const onSubmit = async (e: any) => {
    e.preventDefault();
    setError(null);
    setResult(null);
    setUploadProgress(0);
    setAnalysisProgress(0);
    
    if (!file) {
      setError("Hãy chọn một ảnh khuôn mặt trước.");
      return;
    }
  
    setLoading(true);
    
    // Variables to track intervals for cleanup
    let processingInterval: NodeJS.Timeout | null = null;
    let uploadInterval: NodeJS.Timeout | null = null;
    let analysisInterval: NodeJS.Timeout | null = null;
  
    try {
      // Process image (resize and compress) - 0-30% of progress
      setUploadProgress(0);
      setAnalysisProgress(0);
      
      // Processing phase (0-30%)
      processingInterval = setInterval(() => {
        setUploadProgress((prev: number) => {
          if (prev < 30) return prev + 1;
          if (processingInterval) clearInterval(processingInterval);
          return 30;
        });
      }, 50);
      
      const processedImage = await processImageForUpload(file);
      
      if (processingInterval) {
        clearInterval(processingInterval);
        processingInterval = null;
      }
      setUploadProgress(30); // Processing complete
      
      // Upload phase (30-60%)
      uploadInterval = setInterval(() => {
        setUploadProgress((prev: number) => {
          if (prev < 60) return prev + 1;
          if (uploadInterval) clearInterval(uploadInterval);
          return 60;
        });
      }, 30);
      
      const res = await fetch("/api/analyze", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ imageBase64: processedImage.base64, mimeType: processedImage.mimeType })
      });
      
      if (uploadInterval) {
        clearInterval(uploadInterval);
        uploadInterval = null;
      }
      setUploadProgress(100); // Upload complete
      
      // Analysis phase (0-100%)
      analysisInterval = setInterval(() => {
        setAnalysisProgress((prev: number) => {
          if (prev < 100) return prev + 2;
          if (analysisInterval) clearInterval(analysisInterval);
          return 100;
        });
      }, 50);
      
      const data = await res.json();
      if (analysisInterval) {
        clearInterval(analysisInterval);
        analysisInterval = null;
      }
      setAnalysisProgress(100); // Analysis complete
      
      if (!res.ok) throw new Error(data?.error || "Phân tích thất bại");
      if (!data) throw new Error("Dữ liệu phản hồi không hợp lệ");
      
      // Thêm imageUrl vào kết quả nếu có file ảnh
      if (file && previewUrl) {
        const resultWithImage = {
          ...data,
          imageUrl: previewUrl
        } as SkincareRoutine;
        setResult(resultWithImage);
      } else {
        setResult(data as SkincareRoutine);
      }
    } catch (err: any) {
      // Stop any running intervals in case of error
      if (processingInterval) clearInterval(processingInterval);
      if (uploadInterval) clearInterval(uploadInterval);
      if (analysisInterval) clearInterval(analysisInterval);
      setError(err?.message ?? "Đã xảy ra lỗi.");
    } finally {
      setLoading(false);
      // Ensure progress bars are reset after a delay
      setTimeout(() => {
        setUploadProgress(0);
        setAnalysisProgress(0);
      }, 1000);
    }
  };



  const handleFileChange = (e: any) => {
    if (e.target.files && e.target.files[0]) {
      const selectedFile = e.target.files[0];
      validateAndSetFile(selectedFile);
    }
  };



  const validateAndSetFile = (selectedFile: File) => {
    // Validate file type
    if (!selectedFile.type || !selectedFile.type.match('image.*')) {
      setError("Vui lòng chọn một tệp hình ảnh");
      return;
    }
    // Validate file size (max 10MB)
    if (selectedFile.size > 10 * 1024 * 1024) {
      setError("Kích thước ảnh quá lớn. Vui lòng chọn ảnh dưới 10MB.");
      return;
    }
    // Additional validation: check if file has a valid name
    if (!selectedFile.name) {
      setError("Tệp không hợp lệ");
      return;
    }
    
    // Revoke previous preview URL if exists
    if (previewUrl) {
      URL.revokeObjectURL(previewUrl);
    }
    
    // Create new preview URL
    const newPreviewUrl = URL.createObjectURL(selectedFile);
    setPreviewUrl(newPreviewUrl);
    setFile(selectedFile);
    setError(null);
  };



  const handleDrag = useCallback((e: any) => {
    e.preventDefault();
    e.stopPropagation();
    if (e.type === 'dragenter' || e.type === 'dragover') {
      setIsDragActive(true);
    } else if (e.type === 'dragleave') {
      setIsDragActive(false);
    }
  }, []);



  const handleDrop = useCallback((e: any) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDragActive(false);
    
    if (e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0]) {
      // Thêm kiểm tra lỗi khi nhận file từ thao tác kéo thả
      try {
        const droppedFile = e.dataTransfer.files[0];
        validateAndSetFile(droppedFile);
      } catch (err) {
        setError("Đã xảy ra lỗi khi xử lý tệp được kéo thả");
        console.error("Error handling dropped file:", err);
      }
    }
  }, []);
  
  // Add event listeners for drag and drop
  useEffect(() => {
    const dropZone = document.getElementById('drop-zone');
    if (dropZone) {
      dropZone.addEventListener('dragenter', handleDrag as any);
      dropZone.addEventListener('dragleave', handleDrag as any);
      dropZone.addEventListener('dragover', handleDrag as any);
      dropZone.addEventListener('drop', handleDrop as any);
    }



    return () => {
      if (dropZone) {
        dropZone.removeEventListener('dragenter', handleDrag as any);
        dropZone.removeEventListener('dragleave', handleDrag as any);
        dropZone.removeEventListener('dragover', handleDrag as any);
        dropZone.removeEventListener('drop', handleDrop as any);
      }
    };
  }, [handleDrag, handleDrop]);



  const resetForm = () => {
    // Revoke preview URL if exists
    if (previewUrl) {
      URL.revokeObjectURL(previewUrl);
      setPreviewUrl(null);
    }
    setFile(null);
    setResult(null);
    setError(null);
    setUploadProgress(0);
    setAnalysisProgress(0);
  };
 
  // Hàm hỗ trợ sao chép văn bản
  const fallbackCopyText = (text: string) => {
    if (navigator && navigator.clipboard && typeof navigator.clipboard.writeText === 'function') {
      navigator.clipboard.writeText(text)
        .then(() => alert('Đã sao chép liên kết vào clipboard!'))
        .catch(err => console.error('Error copying:', err));
    } else {
      // Fallback cuối cùng nếu không hỗ trợ clipboard API
      try {
        const textArea = document.createElement('textarea');
        textArea.value = text;
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        const successful = document.execCommand('copy');
        document.body.removeChild(textArea);
        if (successful) {
          alert('Đã sao chép liên kết vào clipboard!');
        } else {
          alert('Không thể sao chép liên kết. Vui lòng sao chép thủ công.');
        }
      } catch (err) {
        console.error('Fallback copy failed:', err);
        alert('Không thể sao chép liên kết. Vui lòng sao chép thủ công.');
      }
    }
  };



  // Cleanup URL object when component unmounts or file changes
  useEffect(() => {
    return () => {
      if (previewUrl) {
        try {
          URL.revokeObjectURL(previewUrl);
        } catch (error) {
          console.error('Error revoking object URL:', error);
        }
      }
    };
  }, [previewUrl]);
 
  return (
    <main className="max-w-4xl mx-auto px-4 py-12">
      <div className="flex justify-between items-center mb-8">
        <Link
          href="/"
          className="border border-primary-600 text-primary-600 hover:bg-primary-50 font-medium py-2 px-4 rounded-lg transition duration-300 ease-in-out flex items-center"
        >
          <svg className="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
          </svg>
          Trở về trang chủ
        </Link>
        <h1 className="text-4xl font-bold text-gray-900 text-center flex-1">Phân tích da thông minh bằng AI</h1>
      </div>
      <div className="text-center mb-4">
        <p className="text-xl text-gray-600 max-w-2xl mx-auto">
          Tải lên ảnh khuôn mặt để nhận phân tích chuyên sâu và lộ trình chăm sóc da cá nhân hóa
        </p>
      </div>



      <div className="bg-white rounded-2xl shadow-xl p-8 mb-8">
        <form onSubmit={onSubmit} className="space-y-6">
          <div className="text-center">
            <label className="block text-lg font-medium text-gray-800 mb-4">
              Chọn ảnh khuôn mặt của bạn
            </label>
            <div className="max-w-md mx-auto">
              <div
                id="drop-zone"
                className={`border-2 border-dashed rounded-xl p-8 cursor-pointer relative overflow-hidden transition-all duration-300 ${
                  isDragActive
                    ? 'border-primary-500 bg-primary-100 scale-105'
                    : 'border-primary-300 bg-primary-50 hover:border-primary-400 hover:bg-primary-100'
                }`}
              >
                <input
                  type="file"
                  accept="image/*"
                  onChange={handleFileChange}
                  className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                />
                <div className="flex flex-col items-center justify-center pointer-events-none">
                  <svg className="w-12 h-12 text-primary-500 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                  </svg>
                  <p className="text-primary-700 font-medium">Kéo và thả ảnh vào đây</p>
                  <p className="text-gray-500 text-sm mt-2">hoặc nhấn để chọn</p>
                  <p className="text-gray-400 text-xs mt-2">Hỗ trợ: JPG, PNG dưới 10MB</p>
                </div>
              </div>
            </div>
          </div>
          
          <div className="text-center">
            <button
              type="submit"
              disabled={loading || !file}
              className={`w-full md:w-auto px-8 py-3 rounded-xl text-white font-semibold transform transition-all duration-300 focus:outline-none focus:ring-4 focus:ring-primary-300 focus:ring-opacity-50 ${
                loading || !file
                  ? 'bg-gray-400 cursor-not-allowed'
                  : 'bg-gradient-to-r from-primary-500 to-primary-600 hover:from-primary-600 hover:to-primary-700 hover:shadow-lg hover:shadow-primary-200 active:scale-95'
              }`}
            >
              {loading ? (
                <span className="flex items-center justify-center">
                  <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Đang phân tích...
                </span>
              ) : (
                <span className="flex items-center justify-center">
                  <svg className="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M9 19l3 3m0 0l3-3m-3 3V10"></path>
                  </svg>
                  Phân tích da ngay
                </span>
              )}
            </button>
          </div>
        </form>



        {file && !loading && !result && (
          <div className="mt-8">
            <div className="text-center mb-4">
              <h3 className="text-lg font-medium text-gray-800">Ảnh đã chọn</h3>
            </div>
            <div className="relative mx-auto block border-4 border-white rounded-xl shadow-lg overflow-hidden max-w-xs md:max-w-md bg-gray-100">
              <img
                src={previewUrl || ''}
                alt="Preview"
                className="max-w-full h-auto rounded-lg object-contain max-h-80"
                style={{ minHeight: '200px' }}
                onError={(e) => {
                  console.error('Error loading image preview');
                  setError('Không thể hiển thị ảnh preview');
                }}
              />
              <div className="absolute -top-3 -right-3">
                <button
                  onClick={resetForm}
                  className="bg-red-500 hover:bg-red-600 text-white rounded-full p-2 shadow-lg transform transition-transform duration-200 hover:scale-110 focus:outline-none focus:ring-2 focus:ring-red-300"
                  aria-label="Xóa ảnh"
                >
                  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12"></path>
                  </svg>
                </button>
              </div>
              <div className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/70 to-transparent p-4 text-white text-center">
                <p className="text-sm font-medium truncate">{file.name}</p>
                <p className="text-xs opacity-80">{(file.size / 1024 / 1024).toFixed(2)} MB</p>
              </div>
            </div>
          </div>
        )}



        {loading && (
          <div className="mt-8 space-y-6">
            <div className="text-center mb-6">
              <h3 className="text-lg font-medium text-gray-800">Đang xử lý ảnh của bạn</h3>
              <p className="text-gray-600 mt-1">
                {uploadProgress < 50 ? "Đang xử lý ảnh..." : uploadProgress < 100 ? "Đang tải ảnh lên..." : "Đang phân tích ảnh..."}
              </p>
            </div>
            
            <div className="max-w-md mx-auto">
              {/* Preview ảnh trong trạng thái loading */}
              <div className="relative mx-auto block border-4 border-white rounded-xl shadow-lg overflow-hidden max-w-xs md:max-w-md bg-gray-100 mb-6">
                <img
                  src={previewUrl || ''}
                  alt="Preview"
                  className="max-w-full h-auto rounded-lg object-contain max-h-80 opacity-60"
                  style={{ minHeight: '200px' }}
                />
                <div className="absolute inset-0 flex items-center justify-center">
                  <div className="flex flex-col items-center">
                    <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-primary-500 mb-3"></div>
                    <p className="text-primary-600 font-medium text-center">AI đang phân tích<br/>làn da của bạn...</p>
                  </div>
                </div>
              </div>
              
              {/* Thanh tiến trình nâng cao */}
              <div className="space-y-3">
                <div className="flex justify-between text-sm text-gray-600">
                  <span>Trạng thái:</span>
                  <span>{uploadProgress < 100 ? `${uploadProgress}%` : `${analysisProgress}%`}</span>
                </div>
                
                <div className="relative h-4 bg-gray-200 rounded-full overflow-hidden">
                  <div
                    className="absolute top-0 left-0 h-full bg-gradient-to-r from-primary-400 to-primary-600 transition-all duration-500 ease-out"
                    style={{ width: `${uploadProgress < 100 ? uploadProgress : analysisProgress}%` }}
                  ></div>
                  <div className="absolute inset-0 bg-[linear-gradient(90deg,transparent,rgba(255,255,255,0.5),transparent)] animate-[progress-shine_2s_infinite]"></div>
                </div>
                
                <div className="grid grid-cols-2 gap-2 text-xs mt-4">
                  <div className={`flex items-center ${uploadProgress >= 30 ? 'text-green-600' : 'text-gray-400'}`}>
                    <svg className={`w-4 h-4 mr-1 ${uploadProgress >= 30 ? 'text-green-500' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7"></path>
                    </svg>
                    Xử lý ảnh
                  </div>
                  <div className={`flex items-center ${uploadProgress >= 60 ? 'text-green-600' : uploadProgress >= 30 ? 'text-yellow-500' : 'text-gray-400'}`}>
                    <svg className={`w-4 h-4 mr-1 ${uploadProgress >= 60 ? 'text-green-500' : uploadProgress >= 30 ? 'text-yellow-500' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7"></path>
                    </svg>
                    Tải lên
                  </div>
                  <div className={`flex items-center ${analysisProgress >= 50 ? 'text-green-600' : uploadProgress >= 100 ? 'text-yellow-500' : 'text-gray-400'}`}>
                    <svg className={`w-4 h-4 mr-1 ${analysisProgress >= 50 ? 'text-green-500' : uploadProgress >= 100 ? 'text-yellow-500' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7"></path>
                    </svg>
                    Phân tích
                  </div>
                  <div className={`flex items-center ${analysisProgress >= 100 ? 'text-green-600' : analysisProgress > 0 ? 'text-yellow-500' : 'text-gray-400'}`}>
                    <svg className={`w-4 h-4 mr-1 ${analysisProgress >= 100 ? 'text-green-500' : analysisProgress > 0 ? 'text-yellow-500' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7"></path>
                    </svg>
                    Hoàn tất
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}



        {error && (
          <div className="mt-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-start shadow-sm">
            <div className="flex-shrink-0">
              <svg className="w-6 h-6 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
              </svg>
            </div>
            <div className="ml-3 flex-1">
              <p className="text-red-700 font-medium">Lỗi:</p>
              <p className="text-red-600 mt-1">{error}</p>
            </div>
            <button
              onClick={() => setError(null)}
              className="ml-4 flex-shrink-0 text-red-500 hover:text-red-700 rounded-full p-1 transition-colors duration-200"
              aria-label="Đóng thông báo"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12"></path>
              </svg>
            </button>
          </div>
        )}
      </div>



      {result && (
        <div className="mt-8 bg-gray-50 rounded-2xl p-6">
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-2xl font-bold text-gray-800">Kết quả phân tích da</h2>
            <div className="flex space-x-3">
              <button
                onClick={() => {
                  // Save result to local storage
                  localStorage.setItem('skincareResult', JSON.stringify(result));
                  alert('Kết quả đã được lưu cục bộ!');
                }}
                className="px-4 py-2 rounded-lg bg-blue-100 text-blue-700 font-medium hover:bg-blue-200 transition-colors flex items-center"
              >
                <svg className="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8 7H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3-3m0 0l-3 3m3-3v12"></path>
                </svg>
                Lưu kết quả
              </button>
              <button
                onClick={() => {
                  // Share result via Web Share API
                  const shareData = {
                    title: 'Phân tích da thông minh',
                    text: 'Kết quả phân tích da của tôi',
                    url: window.location.href,
                  };
                  
                  // Kiểm tra trình duyệt có hỗ trợ Web Share API không
                  if (navigator && navigator.share && typeof navigator.share === 'function') {
                    // Kiểm tra xem có phải là HTTPS hay localhost không (yêu cầu của Web Share API)
                    if (location.protocol === 'https:' || location.hostname === 'localhost' || location.hostname === '127.0.0.1') {
                      navigator.share(shareData)
                        .catch(err => console.error('Error sharing:', err));
                    } else {
                      // Nếu không phải HTTPS và không phải localhost, sử dụng clipboard
                      fallbackCopyText(window.location.href);
                    }
                  } else {
                    // Fallback: Copy to clipboard
                    fallbackCopyText(window.location.href);
                  }
                }}
                className="px-4 py-2 rounded-lg bg-green-100 text-green-700 font-medium hover:bg-green-200 transition-colors flex items-center"
              >
                <svg className="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.367 2.684 3 3 0 00-5.367-2.684z"></path>
                </svg>
                Chia sẻ
              </button>
              <button
                onClick={() => window.print()}
                className="px-4 py-2 rounded-lg bg-purple-100 text-purple-700 font-medium hover:bg-purple-200 transition-colors flex items-center"
              >
                <svg className="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path>
                </svg>
                In kết quả
              </button>
              <button
                onClick={() => {
                  // Tạo gợi ý sản phẩm dựa trên kết quả phân tích
                  alert('Chức năng gợi ý sản phẩm đang được phát triển. Sẽ sớm ra mắt!');
                }}
                className="px-4 py-2 rounded-lg bg-yellow-100 text-yellow-700 font-medium hover:bg-yellow-200 transition-colors flex items-center"
              >
                <svg className="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7"></path>
                </svg>
                Gợi ý sản phẩm
              </button>
              <button
                onClick={resetForm}
                className="px-4 py-2 rounded-lg bg-gray-200 text-gray-700 font-medium hover:bg-gray-300 transition-colors"
              >
                Phân tích lại
              </button>
            </div>
          </div>
          <AnalysisResult result={result} />
        </div>
      )}
    </main>
  );
}
