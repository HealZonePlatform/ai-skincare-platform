module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: ['./tsconfig.json'],
    tsconfigRootDir: __dirname
  },
  plugins: ['@typescript-eslint'],
  extends: ['next/core-web-vitals', 'plugin:@typescript-eslint/recommended', 'prettier'],
  rules: {
    'no-console': ['warn', { allow: ['error'] }],
    '@typescript-eslint/no-explicit-any': 'error'
  },
  settings: {
    next: {
      rootDir: ['.']
    }
  }
};
