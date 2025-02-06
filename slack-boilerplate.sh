#!/bin/bash

# Exit on error
set -e

echo "🚀 Creating Slack Bot project with Bolt, TypeScript, and Google Cloud Functions..."

# Create project directory
read -p "Enter project name: " PROJECT_NAME
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Initialize npm project
echo "📦 Initializing npm project..."
npm init -y

# Update package.json with basic configuration
node -e "
const pkg = require('./package.json');
pkg.main = 'lib/index.js';
pkg.scripts = {
    ...pkg.scripts,
    'build': 'tsc',
    'watch': 'tsc -w',
    'deploy': 'gcloud functions deploy slack-bot --runtime nodejs18 --trigger-http --entry-point slackbot --region asia-northeast1',
    'start': 'npm run build && functions-framework --target=slackbot'
};
require('fs').writeFileSync('package.json', JSON.stringify(pkg, null, 2))
"

# Install dependencies
echo "📚 Installing dependencies..."
npm install @slack/bolt @google-cloud/functions-framework
npm install --save-dev typescript @types/node @google-cloud/functions-framework

# Create TypeScript configuration
echo "⚙️ Creating TypeScript configuration..."
cat > tsconfig.json << EOL
{
"compilerOptions": {
    "target": "es2020",
    "module": "commonjs",
    "lib": ["es2020"],
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "lib",
    "rootDir": "src"
},
"include": ["src/**/*"],
"exclude": ["node_modules"]
}
EOL

# Create source directory and main file
echo "📝 Creating source files..."
mkdir -p src
cat > src/index.ts << EOL
import { App } from '@slack/bolt';
import { Request, Response } from '@google-cloud/functions-framework';

const app = new App({
token: process.env.SLACK_BOT_TOKEN,
signingSecret: process.env.SLACK_SIGNING_SECRET,
processBeforeResponse: true
});

// Example command handler
app.command('/hello', async ({ command, ack, say }) => {
await ack();
await say(\`Hello from your bot, <@\${command.user_id}>! 👋\`);
});

// Cloud Function entry point
export const slackbot = async (req: Request, res: Response) => {
const handler = await app.start();
return handler(req, res);
};
EOL

# Create .gitignore
echo "📄 Creating .gitignore..."
cat > .gitignore << EOL
node_modules/
lib/
.env
EOL

# Create .env.example
echo "🔒 Creating .env.example..."
cat > .env.example << EOL
SLACK_BOT_TOKEN=xoxb-your-bot-token
SLACK_SIGNING_SECRET=your-signing-secret
EOL

echo "✨ Project setup complete! Next steps:"
echo "1. cd $PROJECT_NAME"
echo "2. Create .env file with your Slack credentials"
echo "3. Run 'npm run build' to compile TypeScript"
echo "4. Run 'npm start' to test locally"
echo "5. Run 'npm run deploy' to deploy to Google Cloud Functions"

