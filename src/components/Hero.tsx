'use client';

import { motion } from 'framer-motion';

export default function Hero() {
  return (
    <section id="home" className="relative bg-gradient-to-br from-primary-50 to-secondary-50 overflow-hidden">
      {/* Background decoration */}
      <div className="absolute inset-0">
        <div className="absolute -top-40 -right-32 w-80 h-80 bg-primary-200 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob"></div>
        <div className="absolute -bottom-40 -left-32 w-80 h-80 bg-secondary-200 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob animation-delay-2000"></div>
      </div>

      <div className="relative container mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col lg:flex-row items-center justify-between min-h-screen py-20">
          {/* Left content */}
          <div className="flex-1 text-center lg:text-left mb-12 lg:mb-0">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6 }}
            >
              <h1 className="text-4xl md:text-5xl lg:text-6xl font-black text-gray-900 leading-tight mb-6">
                Nâng Tầm{' '}
                <span className="text-gradient bg-gradient-to-r from-primary-600 to-secondary-600 bg-clip-text text-transparent">
                  Hành Trình Chăm Sóc Da
                </span>{' '}
                với AI
              </h1>
              
              <p className="text-lg md:text-xl text-gray-600 mb-8 max-w-2xl mx-auto lg:mx-0">
                Nhận phân tích da chuyên nghiệp và đề xuất cá nhân hóa với nền tảng được hỗ trợ bởi AI của chúng tôi. 
                Độ chính xác 96%, kết quả tức thì chỉ trong 30 giây.
              </p>

              <div className="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
                <a
                  href="#features"
                  className="btn btn-primary text-lg px-8 py-4"
                >
                  Bắt Đầu Miễn Phí
                </a>
                <a
                  href="#how-it-works"
                  className="btn btn-secondary text-lg px-8 py-4"
                >
                  Tìm Hiểu Thêm
                </a>
              </div>

              {/* Stats */}
              <div className="mt-12 flex flex-col sm:flex-row gap-8 justify-center lg:justify-start">
                <div className="text-center">
                  <div className="text-2xl font-bold text-primary-600">10,000+</div>
                  <div className="text-sm text-gray-600">Người Dùng Hài Lòng</div>
                </div>
                <div className="text-center">
                  <div className="text-2xl font-bold text-primary-600">96%</div>
                  <div className="text-sm text-gray-600">Độ Chính Xác</div>
                </div>
                <div className="text-center">
                  <div className="text-2xl font-bold text-primary-600">30 Giây</div>
                  <div className="text-sm text-gray-600">Thời Gian Phân Tích</div>
                </div>
              </div>
            </motion.div>
          </div>

          {/* Right content - App preview */}
          <div className="flex-1 flex justify-center lg:justify-end">
            <motion.div
              initial={{ opacity: 0, scale: 0.8 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ duration: 0.6, delay: 0.2 }}
              className="relative"
            >
              <div className="w-80 h-96 bg-white rounded-3xl shadow-2xl p-6 transform rotate-6 hover:rotate-0 transition-transform duration-300">
                <div className="w-full h-full bg-gradient-to-br from-primary-100 to-secondary-100 rounded-2xl flex items-center justify-center">
                  <div className="text-center">
                    <div className="w-20 h-20 bg-primary-600 rounded-full mx-auto mb-4 flex items-center justify-center">
                      <svg className="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
                      </svg>
                    </div>
                    <h3 className="text-lg font-semibold text-gray-900 mb-2">Phân Tích Da AI</h3>
                    <p className="text-sm text-gray-600">Tải ảnh lên và nhận phân tích chuyên nghiệp tức thì</p>
                  </div>
                </div>
              </div>
            </motion.div>
          </div>
        </div>
      </div>
    </section>
  );
}