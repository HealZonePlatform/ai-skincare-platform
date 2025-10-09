'use client';

import { motion } from 'framer-motion';

const steps = [
  {
    title: "Tải Ảnh Lên",
    description: "Chụp ảnh khuôn mặt rõ ràng với ánh sáng tốt để ghi lại tình trạng da chính xác.",
    number: "01"
  },
  {
    title: "Phân Tích AI",
    description: "Thuật toán AI tiên tiến của chúng tôi phân tích kết cấu da, tông màu, lỗ chân lông, nếp nhăn và nhiều hơn nữa.",
    number: "02"
  },
  {
    title: "Nhận Kết Quả",
    description: "Nhận báo cáo toàn diện với các thông tin chi tiết về tình trạng da hiện tại của bạn.",
    number: "03"
  },
  {
    title: "Kế Hoạch Cá Nhân",
    description: "Nhận quy trình chăm sóc da được tùy chỉnh phù hợp với nhu cầu và mục tiêu cụ thể của bạn.",
    number: "04"
  }
];

const HowItWorks = () => {
  return (
    <section id="how-it-works" className="section-padding bg-gray-50">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <motion.h2 
            className="text-3xl md:text-4xl font-bold text-gray-900 mb-4"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
          >
            Cách Thức <span className="text-primary-600">Hoạt Động</span>
          </motion.h2>
          <motion.p 
            className="text-lg text-gray-600 max-w-2xl mx-auto"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5, delay: 0.1 }}
          >
            Nhận tư vấn chăm sóc da cá nhân hóa thật đơn giản với nền tảng AI của chúng tôi
          </motion.p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {steps.map((step, index) => (
            <motion.div
              key={index}
              className="bg-white p-6 rounded-xl shadow-md relative overflow-hidden"
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.4, delay: index * 0.1 }}
            >
              <div className="absolute top-0 left-0 w-full h-1 bg-primary-600"></div>
              <div className="absolute -left-4 -top-4 w-16 h-16 rounded-full bg-primary-100 flex items-center justify-center">
                <span className="text-2xl font-bold text-primary-600">{step.number}</span>
              </div>
              <div className="mt-4">
                <h3 className="text-xl font-bold text-gray-900 mb-3">{step.title}</h3>
                <p className="text-gray-600">{step.description}</p>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default HowItWorks;