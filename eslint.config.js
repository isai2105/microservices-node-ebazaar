// eslint.config.js
import tseslint from 'typescript-eslint';
import prettierPlugin from 'eslint-plugin-prettier';

export default [
  {
    files: ['**/*.ts'],
    ignores: [
      'node_modules/**',
      'dist/**',
      '**/node_modules/**',
      '**/dist/**',
      '**/coverage/**',
    ],
    languageOptions: {
      parser: tseslint.parser,
      parserOptions: {
        // If you have a base config for TS in the root:
        project: './tsconfig.base.json',
        tsconfigRootDir: process.cwd(),
        sourceType: 'module',
      },
    },
    plugins: {
      '@typescript-eslint': tseslint.plugin,
      prettier: prettierPlugin,
    },
    rules: {
      // TypeScript rules
      '@typescript-eslint/no-unused-vars': [
        'warn',
        { argsIgnorePattern: '^_' },
      ],
      '@typescript-eslint/explicit-function-return-type': 'off',

      // Prettier formatting
      'prettier/prettier': [
        'error',
        {
          endOfLine: 'auto',
        },
      ],

      // General JS/TS rules
      'no-console': 'off',
    },
  },
];
