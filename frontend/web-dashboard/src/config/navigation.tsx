import {
  Activity,
  Box,
  CalendarClock,
  CheckCheck,
  ClipboardList,
  FileText,
  Gauge,
  LifeBuoy,
  Settings2,
  ShieldCheck,
  Sparkles,
  Users
} from 'lucide-react';
import { type LucideIcon } from 'lucide-react';
import { type DashboardRole } from '@/providers/RoleProvider';

export type NavItem = {
  title: string;
  href: string;
  icon: LucideIcon;
  description?: string;
  badgeText?: string;
};

export type NavigationSection = {
  label: string;
  items: NavItem[];
};

export const navigation: Record<DashboardRole, NavigationSection[]> = {
  partner: [
    {
      label: 'Điều hướng chính',
      items: [
        {
          title: 'Tổng quan',
          href: '/partner/overview',
          icon: Gauge,
          description: 'Hiệu suất kênh và KPI quan trọng'
        },
        {
          title: 'Danh mục sản phẩm',
          href: '/partner/products',
          icon: Box,
          description: 'Quản lý sản phẩm, trạng thái duyệt'
        },
        {
          title: 'Báo cáo chiến dịch',
          href: '/partner/insights',
          icon: Activity,
          description: 'Theo dõi chuyển đổi & xu hướng'
        },
        {
          title: 'Tài liệu',
          href: '/partner/resources',
          icon: FileText,
          description: 'Tài liệu hướng dẫn & checklist'
        }
      ]
    },
    {
      label: 'Tiện ích',
      items: [
        {
          title: 'Lịch tư vấn',
          href: '/partner/scheduling',
          icon: CalendarClock
        },
        {
          title: 'Hỗ trợ',
          href: '/support',
          icon: LifeBuoy
        }
      ]
    }
  ],
  expert: [
    {
      label: 'Duyệt sản phẩm',
      items: [
        {
          title: 'Hàng đợi ưu tiên',
          href: '/expert/review-queue',
          icon: ClipboardList,
          description: 'AI gợi ý thứ tự ưu tiên'
        },
        {
          title: 'Chi tiết đánh giá',
          href: '/expert/review-detail',
          icon: Sparkles,
          description: 'Soạn đề xuất duyệt/từ chối'
        },
        {
          title: 'Lịch sử đánh giá',
          href: '/expert/history',
          icon: CheckCheck,
          description: 'Theo dõi phản hồi từ Admin'
        },
        {
          title: 'Bộ tài nguyên',
          href: '/expert/resources',
          icon: FileText,
          description: 'Chuẩn INCI, tài liệu tham khảo'
        }
      ]
    },
    {
      label: 'Tiện ích',
      items: [
        {
          title: 'Lịch tư vấn',
          href: '/expert/scheduling',
          icon: CalendarClock
        },
        {
          title: 'Hỗ trợ',
          href: '/support',
          icon: LifeBuoy
        }
      ]
    }
  ],
  admin: [
    {
      label: 'Điều hành',
      items: [
        {
          title: 'Bảng điều khiển',
          href: '/admin/overview',
          icon: Gauge,
          description: 'Tình trạng hệ thống & cảnh báo'
        },
        {
          title: 'Quản lý người dùng',
          href: '/admin/users',
          icon: Users,
          description: 'CRUD cho Partner / Expert / Admin'
        },
        {
          title: 'Phê duyệt sản phẩm',
          href: '/admin/approvals',
          icon: ShieldCheck,
          description: 'Xử lý đề xuất từ chuyên gia'
        },
        {
          title: 'Cài đặt nền tảng',
          href: '/admin/settings',
          icon: Settings2,
          description: 'Quy trình duyệt & thông số hệ thống'
        }
      ]
    },
    {
      label: 'Báo cáo',
      items: [
        {
          title: 'Báo cáo định kỳ',
          href: '/admin/reports',
          icon: FileText
        },
        {
          title: 'Hỗ trợ',
          href: '/support',
          icon: LifeBuoy
        }
      ]
    }
  ]
};
