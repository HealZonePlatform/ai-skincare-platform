export type TrendPoint = {
  label: string;
  value: number;
};

export type InsightHighlight = {
  id: string;
  title: string;
  description: string;
  impact: 'positive' | 'negative' | 'neutral';
  delta: string;
};
