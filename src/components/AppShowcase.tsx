'use client';

import { motion } from 'framer-motion';

const AppShowcase = () => {
  return (
    <section id="app-showcase" className="section-padding bg-gray-50">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <motion.h2 
            className="text-3xl md:text-4xl font-bold text-gray-900 mb-4"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
          >
            Trải nghiệm ứng dụng <span className="text-primary-600">Mobile</span> của chúng tôi
          </motion.h2>
          <motion.p 
            className="text-lg text-gray-600 max-w-2xl mx-auto"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5, delay: 0.1 }}
          >
            Tải ứng dụng di động để có trải nghiệm chăm sóc da hoàn chỉnh với AI
          </motion.p>
        </div>

        <div className="flex flex-col lg:flex-row items-center justify-between gap-12">
          <motion.div 
            className="flex-1"
            initial={{ opacity: 0, x: -20 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6 }}
          >
            <div className="grid grid-cols-2 gap-6">
              {/* App screenshot mockups */}
              <div className="relative">
                <div className="bg-white rounded-3xl shadow-xl p-4 transform rotate-3 hover:rotate-0 transition-transform duration-300">
                  <div className="bg-gradient-to-br from-primary-100 to-pink-100 rounded-2xl h-80 flex flex-col items-center justify-center p-4">
                    <div className="w-16 h-16 bg-primary-600 rounded-full mb-4 flex items-center justify-center">
                      <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                      </svg>
                    </div>
                    <h3 className="font-bold text-gray-900 text-center">Phân tích da</h3>
                    <p className="text-sm text-gray-600 text-center mt-2">Chụp ảnh để phân tích ngay lập tức</p>
                  </div>
                </div>
              </div>
              
              <div className="relative mt-8">
                <div className="bg-white rounded-3xl shadow-xl p-4 transform -rotate-3 hover:rotate-0 transition-transform duration-300">
                  <div className="bg-gradient-to-br from-primary-100 to-pink-100 rounded-2xl h-80 flex flex-col items-center justify-center p-4">
                    <div className="w-16 h-16 bg-pink-600 rounded-full mb-4 flex items-center justify-center">
                      <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                      </svg>
                    </div>
                    <h3 className="font-bold text-gray-900 text-center">Kết quả</h3>
                    <p className="text-sm text-gray-600 text-center mt-2">Nhận phân tích da chi tiết</p>
                  </div>
                </div>
              </div>
              
              <div className="relative">
                <div className="bg-white rounded-3xl shadow-xl p-4 transform rotate-6 hover:rotate-0 transition-transform duration-300">
                  <div className="bg-gradient-to-br from-primary-100 to-pink-100 rounded-2xl h-80 flex flex-col items-center justify-center p-4">
                    <div className="w-16 h-16 bg-primary-600 rounded-full mb-4 flex items-center justify-center">
                      <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                    </div>
                    <h3 className="font-bold text-gray-900 text-center">Tư vấn</h3>
                    <p className="text-sm text-gray-600 text-center mt-2">Quy trình chăm sóc cá nhân hóa</p>
                  </div>
                </div>
              </div>
              
              <div className="relative mt-8">
                <div className="bg-white rounded-3xl shadow-xl p-4 transform -rotate-6 hover:rotate-0 transition-transform duration-300">
                  <div className="bg-gradient-to-br from-primary-100 to-pink-100 rounded-2xl h-80 flex flex-col items-center justify-center p-4">
                    <div className="w-16 h-16 bg-pink-600 rounded-full mb-4 flex items-center justify-center">
                      <svg className="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                      </svg>
                    </div>
                    <h3 className="font-bold text-gray-900 text-center">Tiến trình</h3>
                    <p className="text-sm text-gray-600 text-center mt-2">Theo dõi cải thiện làn da</p>
                  </div>
                </div>
              </div>
            </div>
          </motion.div>
          
          <motion.div 
            className="flex-1 text-center lg:text-left"
            initial={{ opacity: 0, x: 20 }}
            whileInView={{ opacity: 1, x: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6, delay: 0.2 }}
          >
            <h3 className="text-2xl font-bold text-gray-900 mb-6">Tại sao chọn ứng dụng của chúng tôi?</h3>
            
            <div className="space-y-6">
              <div className="flex items-start">
                <div className="flex-shrink-0 mt-1">
                  <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
                    <svg className="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                    </svg>
                  </div>
                </div>
                <div className="ml-4">
                  <h4 className="font-bold text-gray-900">Phân tích bằng AI</h4>
                  <p className="text-gray-600 mt-1">Thuật toán tiên tiến phân tích da với độ chính xác 96%</p>
                </div>
              </div>
              
              <div className="flex items-start">
                <div className="flex-shrink-0 mt-1">
                  <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
                    <svg className="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                  </div>
                </div>
                <div className="ml-4">
                  <h4 className="font-bold text-gray-900">Kết quả tức thì</h4>
                  <p className="text-gray-600 mt-1">Nhận phân tích toàn diện chỉ trong 30 giây</p>
                </div>
              </div>
              
              <div className="flex items-start">
                <div className="flex-shrink-0 mt-1">
                  <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
                    <svg className="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                    </svg>
                  </div>
                </div>
                <div className="ml-4">
                  <h4 className="font-bold text-gray-900">Quy trình cá nhân hóa</h4>
                  <p className="text-gray-600 mt-1">Kế hoạch chăm sóc da được thiết kế riêng cho bạn</p>
                </div>
              </div>
              
              <div className="flex items-start">
                <div className="flex-shrink-0 mt-1">
                  <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
                    <svg className="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                    </svg>
                  </div>
                </div>
                <div className="ml-4">
                  <h4 className="font-bold text-gray-900">Theo dõi tiến trình</h4>
                  <p className="text-gray-600 mt-1">Giám sát cải thiện làn da theo thời gian</p>
                </div>
              </div>
            </div>
            
            <div className="mt-8">
              <a 
                href="/early-access" 
                className="inline-block bg-primary-600 hover:bg-primary-700 text-white font-medium py-3 px-8 rounded-lg transition duration-300 ease-in-out transform hover:scale-105"
              >
                Tải ứng dụng ngay
              </a>
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  );
};

export default AppShowcase;
