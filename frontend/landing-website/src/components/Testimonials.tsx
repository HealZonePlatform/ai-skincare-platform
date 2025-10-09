'use client';

import { motion } from 'framer-motion';

const testimonials = [
  {
    id: 1,
    name: "Dr. Linh Nguyen",
    role: "Dermatologist, Bach Mai Hospital",
    content: "As a medical professional, I'm impressed with the AI's accuracy in skin analysis. It correctly identified conditions I would typically diagnose, and patients love the personalized recommendations. This is a valuable tool for preventive care.",
    avatar: "/ai-skincare-platform/avatars/linh-nguyen.jpg",
    rating: 5,
    caseStudyLink: "/case-studies/dermatologist-results",
    verified: true
  },
  {
    id: 2,
    name: "Minh Hoang",
    role: "Software Engineer",
    content: "I struggled with acne for years. After 8 weeks using the AI platform, my skin is clearer than it's been since high school. The progress tracking feature kept me motivated throughout my journey.",
    avatar: "/ai-skincare-platform/avatars/minh-hoang.jpg",
    rating: 5,
    caseStudyLink: "/case-studies/engineer-acne-journey",
    verified: true
  },
  {
    id: 3,
    name: "Thuy Duong",
    role: "Beauty Influencer",
    content: "I've tested dozens of skincare apps, but this AI platform stands out. The analysis is remarkably accurate, and the product recommendations have genuinely improved my skin texture and reduced hyperpigmentation significantly.",
    avatar: "/ai-skincare-platform/avatars/thuy-duong.jpg",
    rating: 5,
    caseStudyLink: "/case-studies/influencer-skincare-results",
    verified: true
  },
  {
    id: 4,
    name: "Dr. Hung Pham",
    role: "Cosmetic Surgeon, Tham My Dong A",
    content: "I recommend this platform to my patients for daily skincare maintenance. The AI provides excellent complementary advice between our professional treatments, helping maintain results longer and prevent new issues.",
    avatar: "/ai-skincare-platform/avatars/hung-pham.jpg",
    rating: 4,
    caseStudyLink: "/case-studies/cosmetic-surgeon-perspective",
    verified: true
  },
  {
    id: 5,
    name: "Mai Anh",
    role: "University Student",
    content: "As a student on a budget, I couldn't afford regular dermatologist visits. This app helped me understand my skin type and find affordable products that actually work. My confidence has improved dramatically!",
    avatar: "/ai-skincare-platform/avatars/mai-anh.jpg",
    rating: 5,
    caseStudyLink: "/case-studies/student-budget-skincare",
    verified: true
  },
  {
    id: 6,
    name: "Khanh Tran",
    role: "Working Mother",
    content: "With a busy schedule, I needed an efficient skincare solution. The AI platform created a 5-minute routine that fits my lifestyle. In just 6 weeks, my tired-looking skin looks refreshed and younger.",
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
            What Our <span className="text-primary-600">Users</span> Say
          </motion.h2>
          <motion.p 
            className="text-lg text-gray-600 max-w-2xl mx-auto"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5, delay: 0.1 }}
          >
            Join thousands of satisfied users who have transformed their skin with our AI-powered platform
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
                    Verified
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
                    Read detailed case study →
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