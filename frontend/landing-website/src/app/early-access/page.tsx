'use client';

import { useState } from 'react';
import { motion } from 'framer-motion';
import Link from 'next/link';
import { trackEarlyAccessSignup, trackFormSubmit, identifyUser } from '@/lib/analytics';
import { handleEarlyAccessSignup } from '@/lib/emailService';

export default function EarlyAccessPage() {
  const [email, setEmail] = useState('');
  const [name, setName] = useState('');
  const [errors, setErrors] = useState({
    name: '',
    email: ''
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isSubmitted, setIsSubmitted] = useState(false);

  const validateField = (name: string, value: string) => {
    switch (name) {
      case 'name':
        if (!value.trim()) {
          return 'Name is required';
        } else if (value.trim().length < 2) {
          return 'Name must be at least 2 characters';
        }
        return '';
      case 'email':
        if (!value.trim()) {
          return 'Email is required';
        } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
          return 'Please enter a valid email address';
        }
        return '';
      default:
        return '';
    }
  };

  const handleChange = (field: 'name' | 'email', value: string) => {
    if (field === 'name') {
      setName(value);
    } else {
      setEmail(value);
    }
    
    // Clear error when user starts typing
    if (errors[field]) {
      setErrors(prev => ({ ...prev, [field]: '' }));
    }
  };

  const handleBlur = (field: 'name' | 'email', value: string) => {
    const error = validateField(field, value);
    setErrors(prev => ({ ...prev, [field]: error }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validate all fields
    let isValid = true;
    const newErrors = { ...errors };
    
    const fields = { name, email };
    for (const field in fields) {
      const error = validateField(field, fields[field as keyof typeof fields]);
      if (error) {
        isValid = false;
        newErrors[field as keyof typeof newErrors] = error;
      }
    }
    
    setErrors(newErrors);
    
    if (!isValid) {
      return;
    }
    
    setIsSubmitting(true);

    // Send data to Formspree
    try {
      // Track form submission attempt
      trackFormSubmit('early_access', false); // Track as attempt first
      
      const response = await fetch(process.env.NEXT_PUBLIC_FORMSPREE_ENDPOINT || 'https://formspree.io/f/YOUR_FORM_ID', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ name, email }),
      });

      if (response.ok) {
        // Successfully submitted - track success
        trackFormSubmit('early_access', true);
        trackEarlyAccessSignup(email);
        identifyUser(email, { name, signupType: 'early_access' });
        
        // Send email notifications
        const emailResult = await handleEarlyAccessSignup(email, name);
        if (!emailResult.success) {
          console.error('Email notification error:', emailResult.message);
        }
        
        setIsSubmitted(true);
        setEmail('');
        setName('');
      } else {
        // Handle error response
        console.error('Formspree submission failed:', await response.text());
        trackFormSubmit('early_access', false);
        alert('There was an error submitting your request. Please try again.');
      }
    } catch (error) {
      console.error('Error submitting early access request:', error);
      trackFormSubmit('early_access', false);
      alert('There was an error submitting your request. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-50 to-pink-50">
      {/* Background decoration */}
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -top-40 -right-32 w-80 h-80 bg-primary-200 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob"></div>
        <div className="absolute -bottom-40 -left-32 w-80 h-80 bg-pink-200 rounded-full mix-blend-multiply filter blur-xl opacity-70 animate-blob animation-delay-2000"></div>
      </div>

      <div className="relative container mx-auto px-4 py-12">
        {/* Header */}
        <header className="flex justify-between items-center py-6">
          <Link href="/" className="text-2xl font-bold text-primary-600">
            AI Skincare
          </Link>
          <Link
            href="/"
            className="border border-primary-600 text-primary-600 hover:bg-primary-50 font-medium py-2 px-4 rounded-lg transition duration-300 ease-in-out"
          >
            Quay về trang chủ
          </Link>
        </header>

        <div className="flex flex-col lg:flex-row items-center justify-between min-h-[70vh] py-12">
          {/* Left content - Form */}
          <motion.div 
            className="w-full lg:w-1/2 bg-white rounded-2xl shadow-xl p-8 mb-12 lg:mb-0 lg:mr-8"
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.5 }}
          >
            <div className="text-center mb-8">
              <h1 className="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
                Tải ứng dụng chăm sóc da AI của chúng tôi
              </h1>
              <p className="text-gray-600">
                Ứng dụng chưa có sẵn trên App Store và CH Play. Đăng ký để nhận quyền truy cập sớm vào ứng dụng chăm sóc da AI của chúng tôi
                hoặc nhận thông báo khi chúng tôi chính thức ra mắt!
              </p>
            </div>

            {isSubmitted ? (
              <div className="text-center py-8">
                <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  <svg className="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M5 13l4 4L19 7"></path>
                  </svg>
                </div>
                <h3 className="text-2xl font-bold text-gray-900 mb-2">Cảm ơn bạn!</h3>
                <p className="text-gray-600 mb-6">
                  Chúng tôi đã nhận được thông tin của bạn và sẽ thông báo khi ứng dụng được ra mắt.
                </p>
                <button
                  onClick={() => setIsSubmitted(false)}
                  className="bg-primary-600 hover:bg-primary-700 text-white font-medium py-3 px-6 rounded-lg transition duration-300 ease-in-out"
                >
                  Gửi yêu cầu khác
                </button>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-6">
                <div>
                  <label htmlFor="name" className="block text-sm font-medium text-gray-700 mb-1">
                    Họ và tên
                  </label>
                  <input
                    type="text"
                    id="name"
                    value={name}
                    onChange={(e) => handleChange('name', e.target.value)}
                    onBlur={(e) => handleBlur('name', e.target.value)}
                    required
                    className={`w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition ${
                      errors.name ? 'border-red-500' : 'border-gray-300'
                    }`}
                    placeholder="Nhập họ và tên của bạn"
                  />
                  {errors.name && <p className="mt-1 text-red-500 text-sm">{errors.name}</p>}
                </div>
                
                <div>
                  <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-1">
                    Địa chỉ Email
                  </label>
                  <input
                    type="email"
                    id="email"
                    value={email}
                    onChange={(e) => handleChange('email', e.target.value)}
                    onBlur={(e) => handleBlur('email', e.target.value)}
                    required
                    className={`w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-primary-500 transition ${
                      errors.email ? 'border-red-500' : 'border-gray-300'
                    }`}
                    placeholder="Nhập địa chỉ email của bạn"
                  />
                  {errors.email && <p className="mt-1 text-red-500 text-sm">{errors.email}</p>}
                </div>
                
                <div className="pt-4">
                  <button
                    type="submit"
                    disabled={isSubmitting}
                    className={`w-full bg-primary-600 hover:bg-primary-700 text-white font-medium py-3 px-6 rounded-lg transition duration-300 ease-in-out ${
                      isSubmitting ? 'opacity-75 cursor-not-allowed' : ''
                    }`}
                  >
                    {isSubmitting ? (
                      <span className="flex items-center justify-center">
                        <svg className="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        Đang xử lý...
                      </span>
                    ) : (
                      'Đăng ký truy cập sớm'
                    )}
                  </button>
                </div>
              </form>
            )}
            
            <div className="mt-8 pt-6 border-t border-gray-200 text-center">
              <p className="text-sm text-gray-500">
                Chúng tôi tôn trọng quyền riêng tư của bạn. Thông tin của bạn sẽ chỉ được sử dụng để thông báo về việc ra mắt ứng dụng.
              </p>
            </div>
          </motion.div>

          {/* Right content - Info */}
          <motion.div 
            className="w-full lg:w-1/2 text-center lg:text-left"
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.5, delay: 0.1 }}
          >
            <h2 className="text-3xl font-bold text-gray-900 mb-6">
              Thay đổi hành trình chăm sóc da của bạn với AI
            </h2>
            
            <div className="space-y-6 mb-8">
              <div className="flex items-start">
                <div className="flex-shrink-0 mt-1">
                  <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
                    <svg className="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                  </div>
                </div>
                <div className="ml-4">
                  <h3 className="text-lg font-semibold text-gray-900">Phân tích bằng AI</h3>
                  <p className="text-gray-60 mt-1">Nhận phân tích da chuyên nghiệp với độ chính xác 96% chỉ trong 30 giây</p>
                </div>
              </div>
              
              <div className="flex items-start">
                <div className="flex-shrink-0 mt-1">
                  <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
                    <svg className="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                  </div>
                </div>
                <div className="ml-4">
                  <h3 className="text-lg font-semibold text-gray-90">Kết quả tức thì</h3>
                  <p className="text-gray-600 mt-1">Nhận khuyến nghị cá nhân hóa ngay sau khi phân tích</p>
                </div>
              </div>
              
              <div className="flex items-start">
                <div className="flex-shrink-0 mt-1">
                  <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
                    <svg className="w-5 h-5 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                    </svg>
                  </div>
                </div>
                <div className="ml-4">
                  <h3 className="text-lg font-semibold text-gray-900">Chăm sóc cá nhân hóa</h3>
                  <p className="text-gray-600 mt-1">Quy trình chăm sóc da được thiết kế riêng cho hồ sơ da của bạn</p>
                </div>
              </div>
            </div>
            
            <div className="bg-white rounded-xl shadow-md p-6 inline-block">
              <div className="flex space-x-6">
                <div className="text-center">
                  <div className="text-2xl font-bold text-primary-600">10,000+</div>
                  <div className="text-sm text-gray-600">Người dùng hài lòng</div>
                </div>
                <div className="text-center">
                  <div className="text-2xl font-bold text-primary-60">96%</div>
                  <div className="text-sm text-gray-600">Độ chính xác</div>
                </div>
                <div className="text-center">
                  <div className="text-2xl font-bold text-primary-600">30 giây</div>
                  <div className="text-sm text-gray-600">Thời gian phân tích</div>
                </div>
              </div>
            </div>

            {/* Contact Info */}
            <div className="mt-8 bg-gradient-to-r from-primary-50 to-pink-50 rounded-xl p-6">
              <h3 className="font-bold text-gray-900 mb-4">Liên hệ với Horizon Team:</h3>
              <div className="space-y-2 text-sm">
                <div className="flex items-center">
                  <svg className="w-4 h-4 text-primary-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                  </svg>
                  <span className="text-gray-700">0365265739</span>
                </div>
                <div className="flex items-center">
                  <svg className="w-4 h-4 text-primary-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                  </svg>
                  <span className="text-gray-700">Huỳnh Nhựt Huy - Team Leader</span>
                </div>
                <div className="flex items-center">
                  <svg className="w-4 h-4 text-primary-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                  </svg>
                  <span className="text-gray-700">FPT University HCM</span>
                </div>
              </div>
            </div>
          </motion.div>
        </div>
      </div>

      {/* Animation styles */}
      <style jsx>{`
        @keyframes blob {
          0% { transform: translate(0px, 0px) scale(1); }
          33% { transform: translate(30px, -50px) scale(1.1); }
          66% { transform: translate(-20px, 20px) scale(0.9); }
          100% { transform: translate(0px, 0px) scale(1); }
        }
        .animate-blob {
          animation: blob 7s infinite;
        }
        .animation-delay-2000 {
          animation-delay: 2s;
        }
      `}</style>
    </div>
  );
}
