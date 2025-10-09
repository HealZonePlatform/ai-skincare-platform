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
      question: "What is AI Skincare Platform?",
      answer: "AI Skincare Platform is an innovative application that uses artificial intelligence to analyze your skin condition and provide personalized skincare recommendations. Our technology uses advanced algorithms to assess your skin and suggest products and routines tailored specifically to your needs."
    },
    {
      id: 2,
      question: "How accurate is the skin analysis?",
      answer: "Our AI-powered skin analysis has an accuracy rate of 96%, which is comparable to professional dermatologist assessments. We use high-resolution imaging and machine learning algorithms trained on thousands of skin samples to provide precise analysis."
    },
    {
      id: 3,
      question: "How long does the skin analysis take?",
      answer: "The skin analysis is completed in just 30 seconds. Simply take a photo of your skin in good lighting, and our AI will analyze it and provide personalized recommendations instantly."
    },
    {
      id: 4,
      question: "Is my skin data secure?",
      answer: "Yes, we prioritize your privacy and security. All skin images and personal data are encrypted and stored securely. We never share your information with third parties without your explicit consent. Our platform complies with all relevant data protection regulations."
    },
    {
      id: 5,
      question: "What skin conditions can the AI detect?",
      answer: "Our AI can detect various skin conditions including acne, wrinkles, hyperpigmentation, dryness, oiliness, pore size, and redness. It also assesses your skin type (oily, dry, combination, sensitive) to provide the most appropriate recommendations."
    },
    {
      id: 6,
      question: "Do I need special equipment for the skin analysis?",
      answer: "No special equipment is needed! You can use your smartphone's camera to take the photos required for analysis. We recommend using good lighting and ensuring your face is well-lit for the most accurate results."
    },
    {
      id: 7,
      question: "How often should I use the app?",
      answer: "For best results, we recommend using the app weekly to track changes in your skin condition. However, you can use it as often as you like to monitor your progress and adjust your skincare routine accordingly."
    },
    {
      id: 8,
      question: "Can I get recommendations for specific skin concerns?",
      answer: "Absolutely! Our AI analyzes your skin to identify specific concerns like aging, acne, dryness, or sensitivity, and provides targeted recommendations for each concern. You can also specify concerns during your profile setup for more personalized results."
    },
    {
      id: 9,
      question: "Is the app suitable for all skin types?",
      answer: "Yes, our AI has been trained on diverse skin types and tones to provide accurate analysis for everyone. Whether you have oily, dry, combination, or sensitive skin, our platform can provide relevant recommendations tailored to your unique needs."
    },
    {
      id: 10,
      question: "When will the app be available for download?",
      answer: "We're currently in the final stages of development and testing. Sign up for early access to be notified as soon as the app is available for download on iOS and Android platforms. Early access users will receive special offers and priority support."
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
          <h2 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">Frequently Asked Questions</h2>
          <p className="text-gray-600 max-w-2xl mx-auto">
            Find answers to common questions about our AI skincare platform, technology, and how to get the best results.
          </p>
        </div>

        <div className="mb-8">
          <div className="relative max-w-xl mx-auto">
            <input
              type="text"
              placeholder="Search questions..."
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
              <p>No questions match your search. Try different keywords.</p>
            </div>
          )}
        </div>
      </div>
    </section>
  );
};

export default FAQSection;