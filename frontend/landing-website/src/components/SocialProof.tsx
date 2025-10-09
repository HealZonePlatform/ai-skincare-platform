'use client';

import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';

const SocialProof = () => {
  // Simulate live user counter
  const [liveUsers, setLiveUsers] = useState(12482);
  const [recentSignups, setRecentSignups] = useState([
    { id: 1, name: "Phuong Nguyen", time: "2 minutes ago", location: "Ho Chi Minh City" },
    { id: 2, name: "Anh Duc", time: "5 minutes ago", location: "Hanoi" },
    { id: 3, name: "Thi Minh", time: "8 minutes ago", location: "Da Nang" }
  ]);
  const [newSignup, setNewSignup] = useState<any>(null);

  // Simulate live user counter increasing
  useEffect(() => {
    const interval = setInterval(() => {
      setLiveUsers(prev => prev + Math.floor(Math.random() * 3));
    }, 5000);

    // Simulate new signups
    const signupInterval = setInterval(() => {
      const names = ["Huong Giang", "Minh Quan", "Thi Lan", "Hoang Anh", "Phuc Thinh", "Ngoc Anh"];
      const locations = ["Can Tho", "Hai Phong", "Vung Tau", "Nha Trang", "Hue", "Bien Hoa"];
      const randomName = names[Math.floor(Math.random() * names.length)];
      const randomLocation = locations[Math.floor(Math.random() * locations.length)];
      
      const newSignupItem = {
        id: Date.now(),
        name: randomName,
        time: "just now",
        location: randomLocation
      };
      
      setNewSignup(newSignupItem);
      setRecentSignups(prev => [newSignupItem, ...prev.slice(0, 4)]); // Keep only 5 most recent
    }, 15000); // New signup every 15 seconds

    return () => {
      clearInterval(interval);
      clearInterval(signupInterval);
    };
  }, []);

  return (
    <section className="py-12 bg-gradient-to-r from-primary-50 to-pink-50">
      <div className="container mx-auto px-4">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 items-center">
          {/* Trust Badges */}
          <div className="text-center lg:text-left">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Được giới thiệu trên</h3>
            <div className="flex flex-wrap justify-center lg:justify-start gap-4">
              {['Healthline', 'WebMD', 'Allure', 'VnExpress', 'Tuoi Tre', 'Zing News'].map((publication, index) => (
                <div key={index} className="bg-white px-4 py-2 rounded-lg shadow-sm border border-gray-100 flex items-center">
                  <div className="bg-gray-200 border-2 border-dashed rounded-xl w-16 h-8" />
                  <span className="ml-2 text-sm font-medium text-gray-700">{publication}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Live User Counter */}
          <div className="text-center">
            <div className="text-4xl font-bold text-primary-600">{liveUsers.toLocaleString()}+</div>
            <div className="text-gray-700">Người Dùng Hiện Tại</div>
            <div className="text-sm text-gray-500 mt-1">Tham gia cộng đồng ngay hôm nay</div>
          </div>

          {/* Security Certifications */}
          <div className="text-center lg:text-right">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">Bảo Mật & Tuân Thủ</h3>
            <div className="flex flex-wrap justify-center lg:justify-end gap-3">
              {['GDPR Compliant', 'SOC 2 Type II', 'ISO 27001', 'HIPAA Ready'].map((cert, index) => (
                <div key={index} className="flex flex-col items-center">
                  <div className="bg-green-100 rounded-full p-2 mb-1">
                    <svg className="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>
                    </svg>
                  </div>
                  <span className="text-xs font-medium text-gray-70">{cert}</span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Recent Signups */}
        <div className="mt-12 bg-white rounded-xl shadow-md p-6 border border-gray-100">
          <h3 className="text-lg font-semibold text-gray-900 mb-4 flex items-center">
            <svg className="w-5 h-5 text-green-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M16 7a4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
            </svg>
            Đăng Ký Gần Đây
          </h3>
          <div className="space-y-3">
            {recentSignups.map((signup, index) => (
              <motion.div
                key={signup.id}
                className="flex items-center justify-between py-2 border-b border-gray-100 last:border-0"
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.5 }}
              >
                <div className="flex items-center">
                  <div className="bg-gray-200 border-2 border-dashed rounded-xl w-10 h-10" />
                  <div className="ml-3">
                    <div className="font-medium text-gray-900">{signup.name}</div>
                    <div className="text-sm text-gray-500">{signup.location}</div>
                  </div>
                </div>
                <div className="text-sm text-gray-500">{signup.time}</div>
              </motion.div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};

export default SocialProof;