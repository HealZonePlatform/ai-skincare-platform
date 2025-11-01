export type DashboardUserRole = 'partner' | 'expert' | 'admin';

export type DashboardUser = {
  id: string;
  fullName: string;
  email: string;
  role: DashboardUserRole;
  organisation?: string;
  lastActiveAt: string;
  status: 'active' | 'invited' | 'suspended';
};
