'use client'

import React from 'react';
import type { SkincareRoutine, RoutineStep } from '@/types';

interface AnalysisResultProps {
  /**
   * The full skincare analysis and recommendation returned from the AI.
   */
  result: SkincareRoutine;
}

/**
 * A reusable card component used to display simple pieces of information such
 * as the detected skin type or a list of concerns. Styling is consistent
 * across cards and pulls from the custom Tailwind palette defined in
 * `tailwind.config.js`.
 */
const InfoCard: React.FC<{ title: string; children: React.ReactNode }> = ({
  title,
  children,
}) => (
  <div className="bg-slate-800/50 rounded-xl p-6">
    <h3 className="text-sm font-semibold text-primary-500 uppercase tracking-wider">
      {title}
    </h3>
    <div className="mt-2 text-neutral-200">{children}</div>
  </div>
);

/**
 * A step component that displays the order, name of the step, suggested
 * product type and the reasoning. The coloured index pill uses the
 * brand palette for better visibility against the dark card backgrounds.
 */
const RoutineStepCard: React.FC<{ step: RoutineStep; index: number }> = ({
  step,
  index,
}) => (
  <div className="relative pl-8">
    <div className="absolute left-0 top-0 flex items-center justify-center h-6 w-6 rounded-full bg-primary-600 text-white font-bold text-sm">
      {index + 1}
    </div>
    <h4 className="font-bold text-white">
      {step.step}:{' '}
      <span className="font-medium text-neutral-300">{step.productType}</span>
    </h4>
    <p className="mt-1 text-sm text-neutral-400">{step.reason}</p>
  </div>
);

/**
 * Renders the result of a skin analysis using a card-based layout. It
 * separates the AM and PM routines into columns and uses the custom
 * palette for headings, icons and highlights. A disclaimer box at the
 * bottom reminds users that these are AI-generated suggestions.
 */
export const AnalysisResult: React.FC<AnalysisResultProps> = ({ result }) => {
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

  // Hàm lưu PDF
  const saveAsPDF = () => {
    // In toàn bộ trang để người dùng có thể lưu dưới dạng PDF
    window.print();
  };

  // Hàm lưu kết quả
  const saveResult = () => {
    // Lưu kết quả vào localStorage
    localStorage.setItem('skincareResult', JSON.stringify(result));
    alert('Kết quả đã được lưu cục bộ!');
  };

  // Hàm chia sẻ kết quả
  const shareResult = () => {
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
  };

  return (
    <section className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 -mt-16 mb-24 animate-fade-in">
      <div className="bg-slate-800 rounded-2xl shadow-2xl p-4 sm:p-6 lg:p-8 border border-slate-700">
        {/* Thêm phần nút điều khiển ở đầu component */}
        <div className="flex flex-wrap justify-between items-center mb-6 gap-2">
          <h2 className="text-3xl font-bold text-center text-white flex-1 min-w-fit">
            Kết quả Phân tích & Gợi ý cho bạn
          </h2>
          <div className="flex flex-wrap gap-2 justify-end">
            <button
              onClick={saveResult}
              className="px-3 py-2 rounded-lg bg-blue-600 text-white font-medium hover:bg-blue-700 transition-colors flex items-center text-sm"
              title="Lưu kết quả"
            >
              <svg className="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8 7H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3-3m0 0l-3 3m3-3v12"></path>
              </svg>
              Lưu
            </button>
            <button
              onClick={shareResult}
              className="px-3 py-2 rounded-lg bg-green-600 text-white font-medium hover:bg-green-700 transition-colors flex items-center text-sm"
              title="Chia sẻ kết quả"
            >
              <svg className="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.367 2.684 3 3 0 00-5.367-2.684z"></path>
              </svg>
              Chia sẻ
            </button>
            <button
              onClick={saveAsPDF}
              className="px-3 py-2 rounded-lg bg-purple-600 text-white font-medium hover:bg-purple-700 transition-colors flex items-center text-sm"
              title="Lưu dưới dạng PDF"
            >
              <svg className="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path>
              </svg>
              PDF
            </button>
            <button
              onClick={() => {
                // Tạo gợi ý sản phẩm dựa trên kết quả phân tích
                alert('Chức năng gợi ý sản phẩm đang được phát triển. Sẽ sớm ra mắt!');
              }}
              className="px-3 py-2 rounded-lg bg-yellow-600 text-white font-medium hover:bg-yellow-700 transition-colors flex items-center text-sm"
              title="Gợi ý sản phẩm"
            >
              <svg className="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7"></path>
              </svg>
              SP
            </button>
          </div>
        </div>

        {/* Hiển thị ảnh nếu có */}
        {result.imageUrl && (
          <div className="flex justify-center mb-8">
            <div className="relative max-w-xs mx-auto">
              <img 
                src={result.imageUrl} 
                alt="Ảnh phân tích da" 
                className="w-full h-auto rounded-xl shadow-lg border-2 border-primary-500/30 object-cover max-h-80"
                onError={(e) => {
                  console.error('Không thể tải ảnh:', result.imageUrl);
                  e.currentTarget.style.display = 'none';
                }}
              />
            </div>
          </div>
        )}

        {/* Basic info cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 sm:gap-6 mb-6 sm:mb-8">
          <InfoCard title="Loại Da Của Bạn">
            <p className="text-lg sm:text-xl font-semibold">{result.skinType}</p>
          </InfoCard>
          <InfoCard title="Các Vấn Đề Cần Chú Ý">
            {result.concerns.length > 0 ? (
              <ul className="list-disc list-inside space-y-1">
                {result.concerns.map((concern, index) => (
                  <li key={index}>{concern}</li>
                ))}
              </ul>
            ) : (
              <p>Không phát hiện vấn đề đáng kể.</p>
            )}
          </InfoCard>
        </div>

        {/* AM and PM routines side-by-side on large screens */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 sm:gap-8">
          <div>
            <h3 className="text-xl sm:text-2xl font-bold text-white mb-4 sm:mb-6 flex items-center">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="h-5 sm:h-6 w-5 sm:w-6 mr-2 sm:mr-3 text-primary-400"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"
                />
              </svg>
              Buổi Sáng (AM)
            </h3>
            <div className="space-y-4 sm:space-y-6 border-l-2 border-primary-800/50 ml-3">
              {result.amRoutine.map((step, index) => (
                <RoutineStepCard key={`am-${index}`} step={step} index={index} />
              ))}
            </div>
          </div>
          <div>
            <h3 className="text-xl sm:text-2xl font-bold text-white mb-4 sm:mb-6 flex items-center">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                className="h-5 sm:h-6 w-5 sm:w-6 mr-2 sm:mr-3 text-primary-500"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M20.354 15.354A9 9 0 018.646 3.646 9.03 9.003 0 0012 21a9.03 9.003 0 008.354-5.646z"
                />
              </svg>
              Buổi Tối (PM)
            </h3>
            <div className="space-y-4 sm:space-y-6 border-l-2 border-primary-800/50 ml-3">
              {result.pmRoutine.map((step, index) => (
                <RoutineStepCard key={`pm-${index}`} step={step} index={index} />
              ))}
            </div>
          </div>
        </div>

        {/* Disclaimer box */}
        <div className="mt-8 sm:mt-10 bg-primary-900/40 border border-primary-700 text-primary-300 px-3 sm:px-4 py-3 rounded-lg text-xs sm:text-sm">
          <p className="font-bold">Lưu ý quan trọng:</p>
          <p>{result.disclaimer}</p>
        </div>
      </div>
    </section>
  );
};