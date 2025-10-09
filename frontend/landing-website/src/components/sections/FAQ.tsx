'use client';

import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

interface FAQItem {
  id: number;
  question: string;
  answer: string;
}

const FAQSection = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [openId, setOpenId] = useState<number | null>(null);

  const faqs: FAQItem[] = [
    {
      id: 1,
      question: "AI Skincare Platform là gì?",
      answer: "AI Skincare Platform là một ứng dụng sáng tạo sử dụng trí tuệ nhân tạo để phân tích tình trạng da và đưa ra các khuyến nghị chăm sóc da cá nhân hóa. Công nghệ của chúng tôi sử dụng các thuật toán tiên tiến để đánh giá làn da của bạn và đề xuất các sản phẩm và quy trình phù hợp nhất với nhu cầu của bạn."
    },
    {
      id: 2,
      question: "Độ chính xác của phân tích da như thế nào?",
      answer: "Phân tích da bằng AI của chúng tôi có tỷ lệ chính xác 96%, tương đương với đánh giá của bác sĩ da liễu chuyên nghiệp. Chúng tôi sử dụng hình ảnh độ phân giải cao và thuật toán học máy được đào tạo trên hàng nghìn mẫu da để cung cấp phân tích chính xác."
    },
    {
      id: 3,
      question: "Thời gian phân tích da mất bao lâu?",
      answer: "Phân tích da được hoàn thành chỉ trong 30 giây. Bạn chỉ cần chụp ảnh làn da của mình trong điều kiện ánh sáng tốt, và AI của chúng tôi sẽ phân tích và đưa ra các khuyến nghị cá nhân hóa ngay lập tức."
    },
    {
      id: 4,
      question: "Dữ liệu da của tôi có an toàn không?",
      answer: "Có, chúng tôi ưu tiên quyền riêng tư và bảo mật của bạn. Tất cả hình ảnh da và dữ liệu cá nhân đều được mã hóa và lưu trữ an toàn. Chúng tôi không bao giờ chia sẻ thông tin của bạn với bên thứ ba mà không có sự đồng ý rõ ràng của bạn. Nền tảng của chúng tôi tuân thủ tất cả các quy định bảo vệ dữ liệu liên quan."
    },
    {
      id: 5,
      question: "AI có thể phát hiện những tình trạng da nào?",
      answer: "AI của chúng tôi có thể phát hiện nhiều tình trạng da khác nhau bao gồm mụn, nếp nhăn, tăng sắc tố, khô da, da dầu, kích thước lỗ chân lông và đỏ da. Nó cũng đánh giá loại da của bạn (da dầu, da khô, da hỗn hợp, da nhạy cảm) để đưa ra các khuyến nghị phù hợp nhất."
    },
    {
      id: 6,
      question: "Tôi có cần thiết bị đặc biệt để phân tích da không?",
      answer: "Không cần thiết bị đặc biệt nào! Bạn có thể sử dụng camera điện thoại thông minh để chụp ảnh cần thiết cho việc phân tích. Chúng tôi khuyến nghị sử dụng ánh sáng tốt và đảm bảo khuôn mặt của bạn được chiếu sáng tốt để có kết quả chính xác nhất."
    },
    {
      id: 7,
      question: "Tôi nên sử dụng ứng dụng thường xuyên như thế nào?",
      answer: "Để có kết quả tốt nhất, chúng tôi khuyên bạn nên sử dụng ứng dụng hàng tuần để theo dõi những thay đổi về tình trạng da. Tuy nhiên, bạn có thể sử dụng nó thường xuyên theo ý muốn để theo dõi tiến trình và điều chỉnh quy trình chăm sóc da cho phù hợp."
    },
    {
      id: 8,
      question: "Tôi có thể nhận được khuyến nghị cho các vấn đề da cụ thể không?",
      answer: "Hoàn toàn có thể! AI của chúng tôi phân tích da để xác định các vấn đề cụ thể như lão hóa, mụn, khô da hoặc nhạy cảm và đưa ra các khuyến nghị có mục tiêu cho từng vấn đề. Bạn cũng có thể chỉ định các vấn đề trong quá trình thiết lập hồ sơ để nhận kết quả được cá nhân hóa hơn."
    },
    {
      id: 9,
      question: "Ứng dụng có phù hợp với mọi loại da không?",
      answer: "Có, AI của chúng tôi đã được đào tạo trên nhiều loại và tông màu da khác nhau để cung cấp phân tích chính xác cho tất cả mọi người. Cho dù bạn có da dầu, da khô, da hỗn hợp hay da nhạy cảm, nền tảng của chúng tôi đều có thể đưa ra các khuyến nghị phù hợp với nhu cầu độc đáo của bạn."
    },
    {
      id: 10,
      question: "Khi nào ứng dụng sẽ có sẵn để tải về?",
      answer: "Chúng tôi hiện đang trong giai đoạn cuối của phát triển và kiểm thử. Đăng ký truy cập sớm để được thông báo ngay khi ứng dụng có sẵn để tải về trên các nền tảng iOS và Android. Người dùng truy cập sớm sẽ nhận được các ưu đãi đặc biệt và hỗ trợ ưu tiên."
    }
  ];

  const filteredFAQs = faqs.filter(faq => 
    faq.question.toLowerCase().includes(searchTerm.toLowerCase()) ||
    faq.answer.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const toggleFAQ = (id: number) => {
    setOpenId(openId === id ? null : id);
  };

  return (
    <section className="py-16 bg-white">
      <div className="container mx-auto px-4 max-w-4xl">
        <div className="text-center mb-12">
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Câu Hỏi Thường Gặp</h2>
          <p className="text-gray-600 max-w-2xl mx-auto">
            Tìm câu trả lời cho các câu hỏi phổ biến về nền tảng chăm sóc da AI, công nghệ và cách để có kết quả tốt nhất.
          </p>
        </div>

        <div className="mb-8">
          <div className="relative max-w-xl mx-auto">
            <input
              type="text"
              placeholder="Tìm kiếm câu hỏi..."
              className="w-full px-4 py-3 pl-12 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-50 transition"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
            <svg
              className="absolute left-4 top-3.5 h-5 w-5 text-gray-400"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M21 21l-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
              ></path>
            </svg>
          </div>
        </div>

        <div className="space-y-4">
          {filteredFAQs.length > 0 ? (
            filteredFAQs.map((faq) => (
              <motion.div
                key={faq.id}
                className="border border-gray-200 rounded-xl overflow-hidden"
                initial={false}
              >
                <button
                  className="w-full flex justify-between items-center p-6 text-left bg-gray-50 hover:bg-gray-100 transition"
                  onClick={() => toggleFAQ(faq.id)}
                >
                  <span className="text-lg font-medium text-gray-900">{faq.question}</span>
                  <motion.span
                    animate={{ rotate: openId === faq.id ? 180 : 0 }}
                    transition={{ duration: 0.2 }}
                  >
                    <svg
                      className="h-5 w-5 text-gray-500"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth="2"
                        d="M19 9l-7 7-7-7"
                      ></path>
                    </svg>
                  </motion.span>
                </button>
                <AnimatePresence initial={false}>
                  {openId === faq.id && (
                    <motion.div
                      initial="collapsed"
                      animate="open"
                      exit="collapsed"
                      variants={{
                        open: { opacity: 1, height: "auto" },
                        collapsed: { opacity: 0, height: 0 }
                      }}
                      transition={{ duration: 0.3, ease: "easeInOut" }}
                      className="overflow-hidden"
                    >
                      <div className="p-6 pt-2 text-gray-600 bg-white">
                        {faq.answer}
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>
              </motion.div>
            ))
          ) : (
            <div className="text-center py-8 text-gray-50">
              <p>Không tìm thấy câu hỏi phù hợp. Vui lòng thử từ khóa khác.</p>
            </div>
          )}
        </div>
      </div>
    </section>
  );
};

export default FAQSection;