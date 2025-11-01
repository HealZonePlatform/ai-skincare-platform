import { InsightHighlight } from '@/types/analytics';
import { Product } from '@/types/product';
import { ReviewEntry } from '@/types/review';
import { DashboardUser } from '@/types/user';

export const mockProducts: Product[] = [
  {
    id: 'prd-001',
    code: 'HZ-SERUM-01',
    name: 'Radiant Glow Serum',
    brand: 'Lumina Labs',
    status: 'pending_review',
    category: 'Serum',
    createdAt: '2025-10-12T09:20:00Z',
    updatedAt: '2025-10-18T10:15:00Z',
    highlights: ['Niacinamide 5%', 'Peptide Complex', 'Chứng nhận Dược phẩm'],
    metrics: {
      views: 12560,
      conversionRate: 3.4,
      rating: 4.6,
      reviewTimeInHours: 42
    }
  },
  {
    id: 'prd-002',
    code: 'HZ-CREAM-21',
    name: 'Hydra Barrier Cream',
    brand: 'DermaPlus',
    status: 'approved',
    category: 'Moisturizer',
    createdAt: '2025-09-30T14:12:00Z',
    updatedAt: '2025-10-16T08:05:00Z',
    highlights: ['Ceramide NP', 'Hyaluronic Acid', 'Không hương liệu'],
    metrics: {
      views: 19840,
      conversionRate: 5.8,
      rating: 4.8,
      reviewTimeInHours: 16
    }
  },
  {
    id: 'prd-003',
    code: 'HZ-TONER-05',
    name: 'Calming Skin Toner',
    brand: 'SkinScape',
    status: 'pending_approval',
    category: 'Toner',
    createdAt: '2025-10-08T11:05:00Z',
    updatedAt: '2025-10-19T09:00:00Z',
    highlights: ['Chiết xuất rau má', 'BHA 0.5%', 'pH 5.5'],
    metrics: {
      views: 8670,
      conversionRate: 2.1,
      rating: 4.4,
      reviewTimeInHours: 30
    }
  },
  {
    id: 'prd-004',
    code: 'HZ-MASK-18',
    name: 'Overnight Repair Mask',
    brand: 'Nocturne Skin',
    status: 'rejected',
    category: 'Mask',
    createdAt: '2025-09-18T07:30:00Z',
    updatedAt: '2025-10-14T12:45:00Z',
    highlights: ['Retinol 0.1%', 'Omega-3 Complex', 'Thiếu chứng chỉ an toàn'],
    metrics: {
      views: 5460,
      conversionRate: 1.2,
      rating: 3.2,
      reviewTimeInHours: 78
    }
  },
  {
    id: 'prd-005',
    code: 'HZ-SPF-33',
    name: 'Daily Defense Sunscreen SPF50+',
    brand: 'SolarGuard',
    status: 'approved',
    category: 'Sunscreen',
    createdAt: '2025-09-10T10:45:00Z',
    updatedAt: '2025-10-17T16:20:00Z',
    highlights: ['Broad Spectrum', 'Chống trôi 80 phút', 'Không chứa Oxybenzone'],
    metrics: {
      views: 22430,
      conversionRate: 6.2,
      rating: 4.9,
      reviewTimeInHours: 24
    }
  },
  {
    id: 'prd-006',
    code: 'HZ-SERUM-09',
    name: 'Ultra Repair Ampoule',
    brand: 'HealZone Labs',
    status: 'draft',
    category: 'Serum',
    createdAt: '2025-10-20T18:40:00Z',
    updatedAt: '2025-10-21T09:12:00Z',
    highlights: ['Pro-vitamin B5', 'Peptide Signal', 'Đang hoàn thiện tài liệu'],
    metrics: {
      views: 1430,
      conversionRate: 1.8,
      rating: 0,
      reviewTimeInHours: 0
    }
  }
];

export const mockReviews: ReviewEntry[] = [
  {
    id: 'rvw-1001',
    productId: 'prd-001',
    productName: 'Radiant Glow Serum',
    partnerName: 'Lumina Labs',
    priority: 'urgent',
    submittedAt: '2025-10-19T12:10:00Z',
    status: 'pending_review',
    aiScore: 92,
    expertNotes: 'Cần xác minh thử nghiệm kích ứng da nhạy cảm.'
  },
  {
    id: 'rvw-1002',
    productId: 'prd-003',
    productName: 'Calming Skin Toner',
    partnerName: 'SkinScape',
    priority: 'high',
    submittedAt: '2025-10-18T08:45:00Z',
    status: 'pending_approval',
    aiScore: 88,
    recommendation: 'approve',
    adminFeedback: 'Đang chờ xác nhận chứng nhận FDA.'
  },
  {
    id: 'rvw-1003',
    productId: 'prd-004',
    productName: 'Overnight Repair Mask',
    partnerName: 'Nocturne Skin',
    priority: 'medium',
    submittedAt: '2025-10-15T09:30:00Z',
    status: 'rejected',
    aiScore: 64,
    expertNotes: 'Không đạt tiêu chuẩn an toàn do nồng độ retinol cao.'
  },
  {
    id: 'rvw-1004',
    productId: 'prd-005',
    productName: 'Daily Defense Sunscreen SPF50+',
    partnerName: 'SolarGuard',
    priority: 'low',
    submittedAt: '2025-10-12T11:15:00Z',
    status: 'approved',
    aiScore: 95,
    recommendation: 'approve'
  }
];

export const mockUsers: DashboardUser[] = [
  {
    id: 'usr-001',
    fullName: 'Lan Trần',
    email: 'lan.tran@healzone.ai',
    role: 'admin',
    organisation: 'HealZone HQ',
    lastActiveAt: '2025-10-20T20:30:00Z',
    status: 'active'
  },
  {
    id: 'usr-002',
    fullName: 'Huy Nguyễn',
    email: 'huy.nguyen@luminlabs.co',
    role: 'partner',
    organisation: 'Lumina Labs',
    lastActiveAt: '2025-10-20T19:45:00Z',
    status: 'active'
  },
  {
    id: 'usr-003',
    fullName: 'Bích Phương',
    email: 'bich.phuong@dermaplus.vn',
    role: 'partner',
    organisation: 'DermaPlus',
    lastActiveAt: '2025-10-19T16:25:00Z',
    status: 'invited'
  },
  {
    id: 'usr-004',
    fullName: 'Dr. Minh Đặng',
    email: 'minh.dang@healzone.expert',
    role: 'expert',
    organisation: 'HealZone Clinical Board',
    lastActiveAt: '2025-10-20T21:05:00Z',
    status: 'active'
  },
  {
    id: 'usr-005',
    fullName: 'Giang Lê',
    email: 'giang.le@skinescape.co',
    role: 'partner',
    organisation: 'SkinScape',
    lastActiveAt: '2025-10-18T10:10:00Z',
    status: 'suspended'
  }
];

export const partnerHighlights: InsightHighlight[] = [
  {
    id: 'ins-01',
    title: 'Sản phẩm mới được quan tâm',
    description: 'Radiant Glow Serum đạt 12k lượt xem trong 7 ngày, cao hơn trung bình 54%.',
    impact: 'positive',
    delta: '+54%'
  },
  {
    id: 'ins-02',
    title: 'Cần bổ sung tài liệu',
    description: 'Hydra Barrier Cream thiếu chứng nhận phòng lab cập nhật Q3.',
    impact: 'negative',
    delta: '-1 chứng chỉ'
  },
  {
    id: 'ins-03',
    title: 'Xu hướng thành phần',
    description: 'Các sản phẩm chứa Peptide có tỷ lệ chuyển đổi cao hơn 2.3%.',
    impact: 'positive',
    delta: '+2.3%'
  }
];
