'use client';

import { motion } from 'framer-motion';

const testimonials = [
  {
    id: 1,
    name: "Dr. Linh Nguyen",
    role: "Bác sĩ da liễu, Bệnh viện Bạch Mai",
    content: "Là một chuyên gia y tế, tôi ấn tượng với độ chính xác trong phân tích da của AI. Nó nhận diện chính xác các tình trạng mà tôi thường chẩn đoán, và bệnh nhân rất thích những đề xuất được cá nhân hóa. Đây là một công cụ có giá trị cho việc chăm sóc phòng ngừa.",
    avatar: "/ai-skincare-platform/avatars/linh-nguyen.jpg",
    rating: 5,
    caseStudyLink: "/case-studies/dermatologist-results",
    verified: true
  },
  {
    id: 2,
    name: "Minh Hoang",
    role: "Kỹ sư phần mềm",
    content: "Tôi đã vật lộn với mụn trong nhiều năm. Sau 8 tuần sử dụng nền tảng AI, làn da của tôi sạch hơn so với thời trung học. Tính năng theo dõi tiến trình giúp tôi luôn giữ được động lực trong suốt hành trình.",
    avatar: "/ai-skincare-platform/avatars/minh-hoang.jpg",
    rating: 5,
    caseStudyLink: "/case-studies/engineer-acne-journey",
    verified: true
  },
  {
    id: 3,
    name: "Thuy Duong",
    role: "Người ảnh hưởng về làm đẹp",
    content: "Tôi đã thử hàng chục ứng dụng chăm sóc da, nhưng nền tảng AI này thực sự nổi bật. Việc phân tích rất chính xác, và những đề xuất sản phẩm đã thực sự cải thiện kết cấu da và giảm đáng kể tình trạng thâm nám.",
    avatar: "/ai-skincare-platform/avatars/thuy-duong.jpg",
    rating: 5,
    caseStudyLink: "/case-studies/influencer-skincare-results",
    verified: true
  },
  {
    id: 4,
    name: "Dr. Hung Pham",
    role: "Bác sĩ phẫu thuật thẩm mỹ, Thẩm mỹ Đông Á",
    content: "Tôi giới thiệu nền tảng này cho bệnh nhân để duy trì chăm sóc da hàng ngày. AI cung cấp lời khuyên bổ sung tuyệt vời giữa các liệu trình chuyên nghiệp của chúng tôi, giúp duy trì kết quả lâu hơn và ngăn ngừa các vấn đề mới.",
    avatar: "/ai-skincare-platform/avatars/hung-pham.jpg",
    rating: 4,
    caseStudyLink: "/case-studies/cosmetic-surgeon-perspective",
    verified: true
  },
  {
    id: 5,
    name: "Mai Anh",
    role: "Sinh viên",
    content: "Là một sinh viên có ngân sách hạn hẹp, tôi không thể thường xuyên đi khám bác sĩ da liễu. Ứng dụng này đã giúp tôi hiểu được loại da của mình và tìm được những sản phẩm phù hợp với giá cả. Sự tự tin của tôi đã cải thiện đáng kể!",
    avatar: "/ai-skincare-platform/avatars/mai-anh.jpg",
    rating: 5,
    caseStudyLink: "/case-studies/student-budget-skincare",
    verified: true
  },
  {
    id: 6,
    name: "Khanh Tran",
    role: "Người mẹ đi làm",
    content: "Với lịch trình bận rộn, tôi cần một giải pháp chăm sóc da hiệu quả. Nền tảng AI đã tạo ra một quy trình 5 phút phù hợp với lối sống của tôi. Chỉ sau 6 tuần, làn da mệt mỏi của tôi đã trở nên tươi tắn và trẻ trung hơn.",
    avatar: "/ai-skincare-platform/avatars/khanh-tran.jpg",
    rating: 5,
    caseStudyLink: "/case-studies/busy-mother-skincare",
    verified: true
  }
];

const Testimonials = () => {
  return (
    <section id="testimonials" className="section-padding bg-white">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <motion.h2 
            className="text-3xl md:text-4xl font-bold text-gray-900 mb-4"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
          >
            Đánh Giá Từ <span className="text-primary-600">Người Dùng</span>
          </motion.h2>
          <motion.p 
            className="text-lg text-gray-600 max-w-2xl mx-auto"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5, delay: 0.1 }}
          >
            Tham gia cùng hàng nghìn người dùng hài lòng đã cải thiện làn da của họ với nền tảng AI của chúng tôi
          </motion.p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {testimonials.map((testimonial, index) => (
            <motion.div
              key={testimonial.id}
              className="bg-gray-50 p-6 rounded-xl shadow-sm h-full flex flex-col"
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.4, delay: index * 0.1 }}
            >
              <div className="flex items-center mb-4">
                <div className="flex mr-2">
                  {[...Array(5)].map((_, i) => (
                    <svg 
                      key={i} 
                      className={`w-5 h-5 ${i < testimonial.rating ? 'text-yellow-400' : 'text-gray-300'}`} 
                      fill="currentColor" 
                      viewBox="0 0 20 20"
                    >
                      <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.58 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 0 00.951-.69l1.07-3.292z" />
                    </svg>
                  ))}
                </div>
                {testimonial.verified && (
                  <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                    Đã xác thực
                  </span>
                )}
              </div>
              <p className="text-gray-600 mb-6 italic flex-grow">"{testimonial.content}"</p>
              <div className="mt-auto">
                <div className="flex items-center mb-3">
                  <img 
                    src={testimonial.avatar} 
                    alt={testimonial.name} 
                    className="w-12 h-12 rounded-full object-cover mr-4 border-2 border-white shadow-sm"
                  />
                  <div>
                    <h4 className="font-bold text-gray-900">{testimonial.name}</h4>
                    <p className="text-gray-600 text-sm">{testimonial.role}</p>
                  </div>
                </div>
                {testimonial.caseStudyLink && (
                  <a 
                    href={testimonial.caseStudyLink} 
                    className="inline-block text-primary-600 hover:text-primary-800 text-sm font-medium transition-colors duration-300"
                  >
                    Xem nghiên cứu chi tiết →
                  </a>
                )}
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Testimonials;