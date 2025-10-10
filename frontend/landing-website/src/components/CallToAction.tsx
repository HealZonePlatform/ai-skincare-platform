'use client';

import { motion } from 'framer-motion';
import Link from 'next/link';

const CallToAction = () => {
  return (
    <section className="section-padding bg-gradient-to-r from-primary-600 to-primary-700 text-white">
      <div className="container mx-auto px-4">
        <div className="max-w-4xl mx-auto text-center">
          <motion.h2 
            className="text-3xl md:text-4xl font-bold mb-6"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
          >
            Sẵn sàng để thay đổi làn da của bạn?
          </motion.h2>
          <motion.p 
            className="text-xl mb-8 text-primary-100"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5, delay: 0.1 }}
          >
            Tham gia cùng hàng nghìn người dùng đã đạt được làn da khỏe mạnh hơn với nền tảng AI của chúng tôi.
          </motion.p>
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5, delay: 0.2 }}
            className="flex flex-col sm:flex-row justify-center gap-4"
          >
            <Link
              href="/early-access"
              className="btn-primary bg-white text-primary-600 hover:bg-gray-100"
            >
              Tải ứng dụng ngay
            </Link>
            <Link 
              href="#features" 
              className="btn-outline border-white text-white hover:bg-primary-500"
            >
              Tìm hiểu thêm
            </Link>
          </motion.div>
        </div>
      </div>
    </section>
  );
};

export default CallToAction;
